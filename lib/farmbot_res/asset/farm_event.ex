defmodule Elixir.FarmbotRes.Asset.FarmEvent do
  @moduledoc """
  """

  use FarmbotRes.Asset.Schema, path: "/api/farm_events"

  schema "farm_events" do
    field(:id, :id)
    field(:end_time, :utc_datetime)
    field(:executable_type, :string)
    field(:executable_id, :id)
    field(:repeat, :integer)
    field(:start_time, :utc_datetime)
    field(:time_unit, :string)

    timestamps()
  end

  view farm_event do
    %{
      id: farm_event.id,
      end_time: farm_event.end_time,
      executable_type: farm_event.executable_type,
      executable_id: farm_event.executable_id,
      repeat: farm_event.repeat,
      start_time: farm_event.start_time,
      time_unit: farm_event.time_unit
    }
  end

  def changeset(farm_event, params \\ %{}) do
    farm_event
    |> cast(params, [
      :id,
      :end_time,
      :executable_type,
      :executable_id,
      :repeat,
      :start_time,
      :time_unit
    ])
    |> validate_required([])
  end
end
