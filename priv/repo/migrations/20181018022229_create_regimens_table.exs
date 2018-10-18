defmodule FarmbotRes.Repo.Migrations.CreateRegimensTable do
  use Ecto.Migration

  def change do
    create table("regimens", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:regimen_items, {:array, :map})
      add(:name, :string)
      timestamps()
    end
  end
end
