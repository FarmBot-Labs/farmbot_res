defmodule FarmbotRes.Asset.Tool do
  @moduledoc "A Tool is an item that lives in a ToolSlot"

  use FarmbotRes.Asset.Schema, path: "/api/tools"

  schema "tools" do
    field(:id, :id)
    field(:name, :string)
    timestamps()
  end

  def changeset(tool, params \\ %{}) do
    tool
    |> cast(params, [:id, :name])
    |> validate_required([])
  end
end
