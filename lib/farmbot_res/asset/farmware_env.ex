defmodule Elixir.FarmbotRes.Asset.FarmwareEnv do
  @moduledoc """
  """

  use FarmbotRes.Asset.Schema, path: "/api/farmware_envs"

  schema "farmware_envs" do
    field(:id, :id)
    field(:key, :string)
    field(:value, :string)
    timestamps()
  end

  view farmware_env do
    %{
      id: farmware_env.id,
      key: farmware_env.key,
      value: farmware_env.value
    }
  end

  def changeset(farmware_env, params \\ %{}) do
    farmware_env
    |> cast(params, [:id, :key, :value])
    |> validate_required([])
  end
end
