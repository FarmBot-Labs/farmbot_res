defmodule Elixir.FarmbotRes.Asset.Sync do
  @moduledoc """
  """

  use FarmbotRes.Asset.Schema, path: "/api/device/sync"

  defmodule Item do
    @moduledoc false
    use Ecto.Schema

    @primary_key false
    @behaviour FarmbotRes.API.View
    import FarmbotRes.API.View, only: [view: 2]

    view sync_item do
      %{
        id: sync_item.id,
        updated_at: sync_item.updated_at
      }
    end

    embedded_schema do
      field(:id, :id)
      field(:updated_at, :utc_datetime)
    end

    def changeset(item, params \\ %{})
    def changeset(item, [id, updated_at]) do
      params = %{id: id, updated_at: updated_at}
      item
      |> cast(params, [:id, :updated_at])
      |> validate_required([])
    end
  end

  schema "syncs" do
    timestamps()
    embeds_one(:device, Item)
    embeds_one(:firmware_config, Item)
    embeds_one(:fbos_config, Item)
    embeds_many(:diagnostic_dumps, Item)
    embeds_many(:farm_events, Item)
    embeds_many(:farmware_envs, Item)
    embeds_many(:farmware_installations, Item)
    embeds_many(:peripherals, Item)
    embeds_many(:pin_bindings, Item)
    embeds_many(:points, Item)
    embeds_many(:regimens, Item)
    embeds_many(:sensor_readings, Item)
    embeds_many(:sensors, Item)
    embeds_many(:sequences, Item)
    embeds_many(:tools, Item)
    field(:now, :naive_datetime)
  end

  view sync do
    %{
      device: Item.render(sync.device),
      fbos_config: Item.render(sync.fbos_config),
      firmware_config: Item.render(sync.firmware_config),
      diagnostic_dumps: Enum.map(sync.diagnostic_dumps, &Item.render/1),
      farm_events: Enum.map(sync.farm_events, &Item.render/1),
      farmware_envs: Enum.map(sync.farmware_envs, &Item.render/1),
      farmware_installations: Enum.map(sync.farmware_installations, &Item.render/1),
      peripherals: Enum.map(sync.peripherals, &Item.render/1),
      pin_bindings: Enum.map(sync.pin_bindings, &Item.render/1),
      points: Enum.map(sync.points, &Item.render/1),
      regimens: Enum.map(sync.regimens, &Item.render/1),
      sensor_readings: Enum.map(sync.sensor_readings, &Item.render/1),
      sensors: Enum.map(sync.sensors, &Item.render/1),
      sequences: Enum.map(sync.sequences, &Item.render/1),
      tools: Enum.map(sync.tools, &Item.render/1),
      now: sync.now
    }
  end

  def changeset(sync, params \\ %{}) do
    sync
    |> cast(params, [:now])
    |> cast_embed(:device)
    |> cast_embed(:fbos_config)
    |> cast_embed(:firmware_config)
    |> cast_embed(:diagnostic_dumps)
    |> cast_embed(:farm_events)
    |> cast_embed(:farmware_envs)
    |> cast_embed(:farmware_installations)
    |> cast_embed(:peripherals)
    |> cast_embed(:pin_bindings)
    |> cast_embed(:points)
    |> cast_embed(:regimens)
    |> cast_embed(:sensor_readings)
    |> cast_embed(:sensors)
    |> cast_embed(:sequences)
    |> cast_embed(:tools)
    |> validate_required([])
  end
end
