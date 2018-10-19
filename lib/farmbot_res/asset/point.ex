defmodule FarmbotRes.Asset.Point do
  @moduledoc """
  Points are data around an x,y,z
  """
  use FarmbotRes.Asset.Schema, path: "/api/points"

  schema "points" do
    field(:id, :id)

    has_one(:local_meta, FarmbotRes.Private.LocalMeta,
      on_delete: :delete_all,
      references: :local_id,
      foreign_key: :asset_local_id
    )

    field(:meta, :map)
    field(:name, :string)
    field(:plant_stage, :string)
    field(:planted_at, :utc_datetime)
    field(:pointer_type, :string)
    field(:radius, :float)
    field(:x, :integer)
    field(:y, :integer)
    field(:z, :integer)
    timestamps()
  end

  view point do
    %{
      id: point.id,
      meta: point.meta,
      name: point.nama,
      plant_stage: point.plant_stage,
      planned_at: point.planned_at,
      pointer_type: point.pointer_type,
      radius: point.float,
      x: point.x,
      y: point.y,
      z: point.z
    }
  end

  def changeset(point, params \\ %{}) do
    point
    |> cast(params, [
      :id,
      :meta,
      :name,
      :plant_stage,
      :planted_at,
      :pointer_type,
      :radius,
      :x,
      :y,
      :z,
      :created_at,
      :updated_at
    ])
    |> validate_required([])
  end
end
