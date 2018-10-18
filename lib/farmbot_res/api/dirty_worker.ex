defmodule FarmbotRes.API.DirtyWorker do
  defmacro __using__(module) do
    quote do
      alias FarmbotRes.{Asset, Repo}
      alias FarmbotRes.API

      require Logger
      use GenServer
      @timeout 10000

      @doc "Start an instance of a DirtyWorker"
      def start_link(args) do
        GenServer.start_link(__MODULE__, args)
      end

      @impl GenServer
      def init([]) do
        {:ok, %{module: unquote(module)}, @timeout}
      end

      @impl GenServer
      def handle_info(:timeout, %{module: module} = state) do
        dirty = Asset.list_dirty(module)
        {:noreply, state, {:continue, dirty}}
      end

      @impl GenServer
      def handle_continue([], state) do
        {:noreply, state, @timeout}
      end

      def handle_continue([dirty | rest], %{module: module} = state) do
        path = module.path()

        data =
          Map.from_struct(dirty)
          |> Map.drop([:__meta__])

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
    end
  end
end
