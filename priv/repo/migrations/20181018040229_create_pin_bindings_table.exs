defmodule FarmbotRes.Repo.Migrations.CreatePinBindingsTable do
  use Ecto.Migration

  def change do
    create table("pin_bindings", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:pin_num, :integer)
      add(:sequence_id, :integer)
      add(:special_action, :string)
      timestamps()
    end
  end
end
