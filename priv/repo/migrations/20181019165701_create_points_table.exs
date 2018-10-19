defmodule FarmbotRes.Repo.Migrations.CreatePointsTable do
  use Ecto.Migration

  def change do
    create table("points", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:meta, :map)
      add(:name, :string)
      add(:plant_stage, :string)
      add(:planted_at, :utc_datetime)
      add(:pointer_type, :string)
      add(:radius, :float)
      add(:x, :integer)
      add(:y, :integer)
      add(:z, :integer)
      timestamps()
    end
  end
end
