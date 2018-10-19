defmodule FarmbotRes.Repo.Migrations.CreateSensorsTable do
  use Ecto.Migration

  def change do
    create table("sensors", primary_key: false) do
      add(:local_id, :id, primary_key: true)
      add(:id, :id)
      add(:pin, :integer)
      add(:mode, :integer)
      add(:label, :string)
      timestamps()
    end
  end
end
