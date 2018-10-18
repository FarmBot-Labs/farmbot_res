defmodule FarmbotRes.Repo.Migrations.CreateDevicesTable do
  use Ecto.Migration

  def change do
    create table("devices", primary_key: false) do
      add(:local_id, :id, primary_key: true)
      add(:id, :id)
      add(:name, :string)
      add(:timezone, :string)
      timestamps()
    end
  end
end
