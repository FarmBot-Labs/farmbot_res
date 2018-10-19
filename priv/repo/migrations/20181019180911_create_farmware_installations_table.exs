defmodule Elixir.FarmbotRes.Repo.Migrations.CreateFarmwareInstallationsTable do
  use Ecto.Migration

  def change do
    create table("farmware_installations", primary_key: false) do
      add(:local_id, :binary_id, primary_key: true)
      add(:id, :id)
      add(:url, :string)
      timestamps(inserted_at: :created_at)
    end
  end
end
