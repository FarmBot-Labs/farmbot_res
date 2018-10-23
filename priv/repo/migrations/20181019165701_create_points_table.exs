defmodule FarmbotRes.Repo.Migrations.CreatePointsTable do
  use Ecto.Migration

  def change do
    create table("points", primary_key: false) do
      add(:local_id, :binary_id, primary_key: true)
      add(:id, :id)
      add(:meta, :map)
      add(:name, :string)
      add(:plant_stage, :string)
      add(:planted_at, :utc_datetime)
      add(:pointer_type, :string)
      add(:radius, :float)
      add(:x, :float)
      add(:y, :float)
      add(:z, :float)
      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end
  end
end
