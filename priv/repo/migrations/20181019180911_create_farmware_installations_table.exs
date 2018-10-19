defmodule Elixir.FarmbotRes.Repo.Migrations.CreateFarmwareInstallationsTable do
  use Ecto.Migration

  def change do
    create table("farmware_installations", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:url, :string)
      timestamps()
    end
  end
end
