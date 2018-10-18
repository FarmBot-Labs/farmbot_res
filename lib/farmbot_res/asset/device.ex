defmodule FarmbotRes.Asset.Device do
  @moduledoc """
  The current device. Should only ever be _one_ of these. If not there is a huge
  problem probably higher up the stack.
  """

  use FarmbotRes.Asset.Schema, path: "/api/device"

  schema "devices" do
    field(:id, :id)
    field(:name, :string)
    field(:timezone, :string)
    timestamps()
  end

  def changeset(device, params \\ %{}) do
    device
    |> cast(params, [:id, :name, :timezone])
    |> validate_required([])
  end
end
