defmodule FarmbotRes.Asset.Device do
  @moduledoc """
  The current device. Should only ever be _one_ of these. If not there is a huge
  problem probably higher up the stack.
  """

  use FarmbotRes.Asset.Schema, path: "/api/device"

  schema "devices" do
    field(:id, :id)

    has_one(:local_meta, FarmbotRes.Private.LocalMeta,
      on_delete: :delete_all,
      references: :local_id,
      foreign_key: :asset_local_id
    )

    field(:name, :string)
    field(:timezone, :string)
    timestamps()
  end

  view device do
    %{
      id: device.id,
      name: device.name,
      timezone: device.timezone
    }
  end

  def changeset(device, params \\ %{}) do
    device
    |> cast(params, [:id, :name, :timezone, :created_at, :updated_at])
    |> validate_required([])
  end
end
