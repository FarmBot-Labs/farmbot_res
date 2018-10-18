defmodule FarmbotRes.MixProject do
  use Mix.Project

  def project do
    [
      app: :farmbot_res,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      aliases: ["ecto.setup": ["ecto.drop", "ecto.migrate", "run priv/repo/seeds.exs"]],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FarmbotRes.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sqlite_ecto2, "~> 2.3"},
      {:postgrex, "~> 0.13.5"},
      {:tesla, "~> 1.1"},
      {:jason, "~> 1.1"}
    ]
  end
end
