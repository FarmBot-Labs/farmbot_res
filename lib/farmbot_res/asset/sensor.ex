defmodule FarmbotRes.Asset.Sensor do
  @moduledoc """
  Sensors are descriptors for pins/modes.
  """

  use FarmbotRes.Asset.Schema, path: "/api/sensors"

  schema "sensors" do
    field(:pin, :integer)
    field(:mode, :integer)
    field(:label, :string)
    timestamps()
  end

  def changeset(sensor, params \\ %{}) do
    sensor
    |> cast(params, [:id, :pin, :mode, :label])
    |> validate_required([:id, :pin, :mode, :label])
  end
end
