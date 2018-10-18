defmodule FarmbotRes.Asset do
  @doc "API path for HTTP requests."
  @callback path() :: Path.t()

  @doc "Apply params to a changeset or object."
  @callback changeset(map, map) :: Ecto.Changeset.t()

  alias FarmbotRes.Repo
  alias FarmbotRes.Asset.SensorReading

  import Ecto.Query, warn: false
  import Ecto.Changeset, warn: false

  def list_dirty(module) do
    Repo.all(from(data in module, where: is_nil(data.id)))
  end
end
