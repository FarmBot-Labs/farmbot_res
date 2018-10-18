defmodule FarmbotRes.Asset.Peripheral do
  @moduledoc """
  Peripherals are descriptors for pins/modes.
  """

  use FarmbotRes.Asset.Schema, path: "/api/peripherals"

  schema "peripherals" do
    field(:id, :id)
    field(:pin, :integer)
    field(:mode, :integer)
    field(:label, :string)
    timestamps()
  end

  def changeset(peripheral, params \\ %{}) do
    peripheral
    |> cast(params, [:id, :pin, :mode, :label])
    |> validate_required([:id, :pin, :mode, :label])
  end
end
