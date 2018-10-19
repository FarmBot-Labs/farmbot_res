defmodule FarmbotRes.Asset do
  @doc "API path for HTTP requests."
  @callback path() :: Path.t()

  @doc "Apply params to a changeset or object."
  @callback changeset(map, map) :: Ecto.Changeset.t()
end
