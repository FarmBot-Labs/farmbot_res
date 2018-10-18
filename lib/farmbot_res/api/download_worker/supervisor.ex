defmodule FarmbotRes.API.DownloadWoker.Supervisor do
  alias FarmbotRes.API
  alias FarmbotRes.API.DownloadWoker
  alias FarmbotRes.Asset.{
    Device,
    SensorReading
  }
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, [name: __MODULE__])
  end

  def init([]) do
    children = [
      {FarmbotRes.API.DownloadWoker, [module: Device, function: &API.device/0]},
      {FarmbotRes.API.DownloadWoker, [module: SensorReading, function: &API.sensor_readings/0]}
    ]
    Supervisor.init(children, [strategy: :one_for_one])
  end
end
