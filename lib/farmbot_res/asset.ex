defmodule FarmbotRes.Asset do
  @doc "API path for HTTP requests."
  @callback path() :: Path.t()

  @doc "Apply params to a changeset or object."
  @callback changeset(map, map) :: Ecto.Changeset.t()

  alias FarmbotRes.Repo
  alias FarmbotRes.Asset.{FbosConfig, FirmwareConfig}

  import Ecto.Query

  def fbos_config() do
    Repo.one(FbosConfig) || %FbosConfig{}
  end

  def fbos_config(field) do
    Map.fetch!(fbos_config(), field)
  end

  def firmware_config() do
    Repo.one(FirmwareConfig) || %FirmwareConfig{}
  end

  def firmware_config(field) do
    Map.fetch!(firmware_config(), field)
  end
end
