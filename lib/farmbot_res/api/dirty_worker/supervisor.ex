defmodule FarmbotRes.API.DirtyWorker.Supervisor do
  use DynamicSupervisor
  alias FarmbotRes.API.DirtyWorker
  # alias FarmbotRes.Asset.{
  #   FbosConfig,
  #   FirmwareConfig
  # }

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_worker(module) when is_atom(module) do
    spec = {DirtyWorker, module}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def init(_args) do
    DynamicSupervisor.init(
      strategy: :one_for_one
      # extra_arguments: args
    )
  end
end
