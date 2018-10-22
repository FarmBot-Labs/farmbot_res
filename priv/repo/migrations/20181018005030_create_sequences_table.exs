defmodule FarmbotRes.Repo.Migrations.CreateSequencesTable do
  use Ecto.Migration

  def change do
    create table("sequences", primary_key: false) do
      add(:local_id, :binary_id, primary_key: true)
      add(:id, :id)
      add(:name, :string)
      add(:kind, :string)
      add(:args, :binary)
      add(:body, :binary)
      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end
  end
end
