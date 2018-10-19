defmodule Elixir.FarmbotRes.Repo.Migrations.CreateDiagnosticDumpsTable do
  use Ecto.Migration

  def change do
    create table("diagnostic_dumps", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:ticket_identifier, :string)
      add(:fbos_commit, :string)
      add(:fbos_version, :string)
      add(:firmware_commit, :string)
      add(:firmware_state, :string)
      add(:network_interface, :string)
      add(:fbos_dmesg_dump, :string)
      timestamps()
    end
  end
end
