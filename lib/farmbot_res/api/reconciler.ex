defmodule FarmbotRes.API.Reconciler do
  require Logger
  alias Ecto.{Changeset, Multi}
  import Ecto.Query

  alias FarmbotRes.{API, Repo}
  alias FarmbotRes.Asset.Sync
  alias API.{SyncGroup, EagerLoader}

  def sync do
    Logger.configure(level: :info)
    # Get the sync changeset
    sync_changeset = API.get_changeset(Sync)
    sync = Changeset.apply_changes(sync_changeset)

    multi = Multi.new()

    with {:ok, multi} <- sync_group(multi, sync, SyncGroup.group_1()),
         {:ok, multi} <- sync_group(multi, sync, SyncGroup.group_2()),
         {:ok, multi} <- sync_group(multi, sync, SyncGroup.group_3()),
         {:ok, multi} <- sync_group(multi, sync, SyncGroup.group_4()) do
      Multi.insert(multi, :syncs, sync_changeset)
      |> Repo.transaction()
    end
  end

  def sync_group(multi, sync, [module | rest]) do
    table = module.__schema__(:source) |> String.to_atom()
    items = Map.fetch!(sync, table)

    # TODO(Connor) make this reduce async with Task/Agent
    multi = Enum.reduce(items, multi, &multi_reduce(module, table, &1, &2))

    sync_group(multi, sync, rest)
  end

  def sync_group(multi, _sync, []), do: {:ok, multi}

  @doc false
  def multi_reduce(module, table, item, multi) do
    cached_cs = EagerLoader.get_cache(module, item.id)
    local_item = Repo.one(from(d in module, where: d.id == ^item.id))

    case local_item do
      nil ->
        Logger.info("local version doesn't exist. downloading: #{module} => #{inspect(item)}")

        cs = API.get_changeset(module, "#{item.id}")
        Multi.insert(multi, {table, item.id}, cs)

      %{} ->
        case get_changeset(local_item, item, cached_cs) do
          %Changeset{} = cs -> Multi.update(multi, {table, item.id}, cs)
          nil ->
            Logger.info "Local data: #{local_item.__struct__} is current."
            multi
        end
    end
  end

  defp get_changeset(local_item, sync_item, cached_cs)

  # no cache available
  # If the `sync_item.updated_at` is newer than `local_item.updated_at`
  # HTTP get the data.
  defp get_changeset(local_item, sync_item, nil) do
    # Check if remote data is newer
    if DateTime.compare(sync_item.updated_at, local_item.updated_at) == :gt do
      Logger.info "Local data: #{local_item.__struct__} is out of date. Using HTTP to get newer data."
      API.get_changeset(local_item, "#{sync_item.id}")
    end
  end

  # We have a cache.
  # First check if it is the same `updated_at` as what the API has.
  # If the cache is the same `updated_at` as the API, check if the cache
  # is newer than `local_item.updated_at`
  # if the cache is not the same `updated_at` as the API, fallback to HTTP.
  defp get_changeset(local_item, sync_item, %Changeset{} = cached) do
    cached_updated_at = Changeset.get_field(cached, :updated_at)
    if DateTime.compare(sync_item.updated_at, cached_updated_at) == :eq do
      if DateTime.compare(cached_updated_at, local_item.updated_at) == :gt do
        Logger.info "Local data: #{local_item.__struct__} is out of date. Using cache do get newer data."
        cached
      end
    else
      Logger.info "Cached item is out of date"
      get_changeset(local_item, sync_item, nil)
    end
  end
end
