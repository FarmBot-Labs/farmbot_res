defmodule FarmbotRes.API.EagerLoader do
  @moduledoc "Handles caching of asset changes"
  alias Ecto.Changeset
  require Logger
  use GenServer

  def get_cache(module, id) do
    pid(module)
    |> GenServer.call({:get_cache, id})
  end

  def cache(%Changeset{data: %module{}} = changeset) do
    id = Changeset.get_field(changeset, :id)
    id || raise("Can't cache changeset with no id.")
    pid(module)
    |> GenServer.cast({:cache, id, changeset})
  end

  defp pid(module) do
    Supervisor.which_children(FarmbotRes.API.EagerLoader.Supervisor)
    |> Enum.find_value(fn {{FarmbotRes.API.EagerLoader, child_module}, pid, :worker, _} ->
      module == child_module && pid
    end)
  end

  @doc false
  def child_spec(module) when is_atom(module) do
    %{
      id: {FarmbotRes.API.EagerLoader, module},
      start: {__MODULE__, :start_link, [[module: module]]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    module = Keyword.fetch!(args, :module)
    {:ok, %{module: module, cache: %{}}}
  end

  def handle_cast({:cache, id, changeset}, state) do
    {:noreply, %{state | cache: Map.put(state.cache, id, changeset)}}
  end

  def handle_call({:get_cache, id}, _, state) do
    {result, cache} = Map.pop(state.cache, id)
    {:reply, result, %{state | cache: cache}}
  end
end
