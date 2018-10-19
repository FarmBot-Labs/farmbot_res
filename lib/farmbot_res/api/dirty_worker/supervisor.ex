defmodule FarmbotRes.API.DirtyWorker.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init([]) do
    children = [
      FarmbotRes.API.DirtyWorker.SensorReading,
      FarmbotRes.API.DirtyWorker.Point
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
