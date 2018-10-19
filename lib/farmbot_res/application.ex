defmodule FarmbotRes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      FarmbotRes.Repo,
      # FarmbotRes.API.DirtyWorker.Supervisor
    ]

    opts = [strategy: :one_for_one, name: FarmbotRes.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
