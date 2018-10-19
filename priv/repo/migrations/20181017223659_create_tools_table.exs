defmodule FarmbotRes.Repo.Migrations.CreateToolsTable do
  use Ecto.Migration

  def change do
    create table("tools", primary_key: false) do
      add(:local_id, :binary_id, primary_key: true)
      add(:id, :id)
      add(:name, :string)
      timestamps(inserted_at: :created_at)
    end
  end
end
