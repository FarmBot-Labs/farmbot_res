defmodule Elixir.FarmbotRes.Repo.Migrations.CreateFarmwareEnvsTable do
  use Ecto.Migration

  def change do
    create table("farmware_envs", primary_key: false) do
      add(:local_id, :uuid, primary_key: true)
      add(:id, :id)
      add(:key, :string)
      add(:value, :string)
      timestamps()
    end
  end
end
