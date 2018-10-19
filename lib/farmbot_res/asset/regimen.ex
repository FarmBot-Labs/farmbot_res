defmodule FarmbotRes.Asset.Regimen do
  @moduledoc """
  A Regimen is a schedule to run sequences on.
  """

  use FarmbotRes.Asset.Schema, path: "/api/regimens"

  defmodule Item do
    use Ecto.Schema

    @primary_key false
    @behaviour FarmbotRes.API.View
    import FarmbotRes.API.View, only: [view: 2]

    view regimen_item do
      %{
        time_offset: regimen_item.time_offset,
        sequence_id: regimen_item.sequence_id
      }
    end

    embedded_schema do
      field(:time_offset, :integer)
      # Can't use real references here.
      field(:sequence_id, :id)
    end

    def changeset(item, params \\ %{}) do
      item
      |> cast(params, [:time_offset, :sequence_id])
      |> validate_required([])
    end
  end

  schema "regimens" do
    field(:id, :id)
    field(:name, :string)
    embeds_many(:regimen_items, Item)
    field(:farm_event_id, :integer, virtual: true)
    timestamps()
  end

  view regimen do
    %{
      id: regimen.id,
      name: regimen.name,
      regimen_items: Enum.map(regimen.items, &Item.render(&1))
    }
  end

  def changeset(regimen, params \\ %{}) do
    regimen
    |> cast(params, [:id, :name])
    |> cast_embed(:regimen_items)
    |> validate_required([])
  end
end
