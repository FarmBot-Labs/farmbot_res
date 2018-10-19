defmodule FarmbotRes.API.DirtyWorker do
  alias FarmbotRes.{Asset, Repo}
  alias FarmbotRes.API
  import API.View, only: [render: 2]

  require Logger
  use GenServer
  @timeout 10000

  @impl GenServer
  def init(args) do
    module = Keyword.fetch!(args, :module)
    timeout = Keyword.get(args, :timeout, @timeout)
    {:ok, %{module: module, timeout: timeout}, timeout}
  end

  @impl GenServer
  def handle_info(:timeout, %{module: module} = state) do
    dirty = Asset.list_dirty(module)
    {:noreply, state, {:continue, dirty}}
  end

  @impl GenServer
  def handle_continue([], state) do
    {:noreply, state, state.timeout}
  end

  def handle_continue([dirty | rest], %{module: module} = state) do
    path = module.path()

    data = render(state.module, dirty)

    case API.post(API.client(), path, data) do
      # Valid data
      {:ok, %{status: s, body: body}} when s > 199 and s < 300 ->
        dirty |> module.changeset(body) |> handle_changeset(rest, state)

      # Invalid data
      {:ok, %{status: s, body: body}} when s > 399 and s < 500 ->
        changeset = module.changeset(dirty)

        Enum.reduce(body, changeset, fn {key, val}, changeset ->
          Ecto.Changeset.add_error(changeset, key, val)
        end)
        |> handle_changeset(rest, state)

      # HTTP Error. (500, network error, timeout etc.)
      _ ->
        {:noreply, state, @timeout}
    end
  end

  # If the changeset was valid, update the record.
  def handle_changeset(%{valid?: true} = changeset, rest, state) do
    Logger.debug("Successfully synced: #{state.module}", changeset: changeset)
    _ = Repo.update!(changeset)
    {:noreply, state, {:continue, rest}}
  end

  # If the changeset was invalid, delete the record.
  def handle_changeset(%{valid?: false, data: data} = changeset, rest, state) do
    message =
      Enum.map(changeset.errors, fn {key, val} ->
        "#{key}: #{val}"
      end)
      |> Enum.join("\n")

    Logger.error("Failed to sync: #{state.module} #{message}", changeset: changeset)
    _ = Repo.delete!(data)
    {:noreply, state, {:continue, rest}}
  end

  @doc "Defines a child_spec and start_link/1 function"
  defmacro __using__(module) do
    quote do
      @doc false
      def child_spec(opts) do
        %{
          id: {FarmbotRes.API.DirtyWorker, unquote(module)},
          start: {__MODULE__, :start_link, [opts]},
          type: :worker,
          restart: :permanent,
          shutdown: 500
        }
      end

      @doc "Start an instance of a DirtyWorker"
      def start_link(args) do
        args = Keyword.merge(args, module: unquote(module))
        GenServer.start_link(FarmbotRes.API.DirtyWorker, args)
      end
    end
  end
end
