defmodule FarmbotRes.Asset.SensorReading do
  @moduledoc """
  SensorReadings are descriptors for pins/modes.
  """

  use FarmbotRes.Asset.Schema, path: "/api/sensor_readings"

  schema "sensor_readings" do
    field(:id, :id)
    field(:mode, :integer)
    field(:pin, :integer)
    field(:value, :integer)
    field(:x, :float)
    field(:y, :float)
    field(:z, :float)
    field(:created_at, :utc_datetime)
    timestamps()
  end

  def changeset(sensor, params \\ %{}) do
    sensor
    |> cast(params, [:id, :mode, :pin, :value, :x, :y, :z, :created_at])
    |> validate_required([])
  end
end
