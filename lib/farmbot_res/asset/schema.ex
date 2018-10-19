defmodule FarmbotRes.Asset.Schema do
  @moduledoc """
  Common Schema attributes.
  """

  @doc false
  defmacro __using__(opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @behaviour FarmbotRes.Asset
      @behaviour FarmbotRes.API.View

      import FarmbotRes.API.View, only: [view: 2]

      @doc "Path on the Farmbot Web API"
      def path, do: Keyword.fetch!(unquote(opts), :path)
      @primary_key {:local_id, :binary_id, autogenerate: true}
      @timestamps_opts inserted_at: :created_at
    end
  end
end
