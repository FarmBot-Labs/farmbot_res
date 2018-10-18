defmodule FarmbotRes.Repo.Migrations.CreatePeripheralsTable do
  use Ecto.Migration

  def change do
    create table("peripherals", primary_key: false) do
      add(:local_id, :id, primary_key: true)
      add(:id, :id)
      add(:pin, :integer)
      add(:mode, :integer)
      add(:label, :string)
      timestamps()
    end
  end
end
