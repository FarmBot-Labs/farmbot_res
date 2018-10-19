defmodule FarmbotRes.Asset.Sequence do
  @moduledoc """
  Sequences are "code" that FarmbotOS can Execute.
  """

  use FarmbotRes.Asset.Schema, path: "/api/sequences"

  schema "sequences" do
    field(:id, :id)

    has_one(:local_meta, FarmbotRes.Private.LocalMeta,
      on_delete: :delete_all,
      references: :local_id,
      foreign_key: :asset_local_id
    )

    field(:name, :string)
    field(:kind, :string)
    field(:args, :map)
    field(:body, {:array, :map})
    timestamps()
  end

  view sequence do
    %{
      id: sequence.id,
      name: sequence.name,
      kind: sequence.kind,
      args: sequence.args,
      body: sequence.body
    }
  end

  def changeset(device, params \\ %{}) do
    device
    |> cast(params, [:id, :args, :name, :kind, :body, :created_at, :updated_at])
    |> validate_required([])
  end
end
