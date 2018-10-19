defmodule Elixir.FarmbotRes.Asset.FarmwareInstallation do
  @moduledoc """
  """

  use FarmbotRes.Asset.Schema, path: "/api/farmware_installations"

  schema "farmware_installations" do
    field(:id, :id)
    field(:url, :string)
    timestamps()
  end

  view farmware_installation do
    %{
      id: farmware_installation.id,
      url: farmware_installation.url
    }
  end

  def changeset(farmware_installation, params \\ %{}) do
    farmware_installation
    |> cast(params, [:id, :url])
    |> validate_required([])
  end
end
