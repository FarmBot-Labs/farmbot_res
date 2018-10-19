use Mix.Config
config :ecto, :json_library, Jason
config :farmbot_res, ecto_repos: [FarmbotRes.Repo]

config :farmbot_res, FarmbotRes.Repo,
  adapter: Sqlite.Ecto2,
  database: "farmbot_res.#{Mix.env()}.sqlite"
