defmodule FarmbotRes.Repo.Migrations.CreateFarmEventsTable do
  use Ecto.Migration

  def change do
    create table("farm_events", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:end_time, :utc_datetime)
      add(:executable_type, :string)
      add(:executable_id, :id)
      add(:repeat, :integer)
      add(:start_time, :utc_datetime)
      add(:time_unit, :string)
    end
  end
end
