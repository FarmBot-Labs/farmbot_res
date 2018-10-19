defmodule Mix.Tasks.FarmbotRes.Gen.Asset do
  @moduledoc "Generate a FarmbotRes.Asset module"
  use Mix.Task

  def run([module_str, plural_str]) do
    module_cam = Macro.camelize(module_str)
    module_snake = Macro.underscore(module_str)
    module = Module.concat(FarmbotRes.Asset, module_cam)
    migration_name_cam = Macro.camelize("create_#{plural_str}_table")
    migration_module_name = Module.concat(FarmbotRes.Repo.Migrations, migration_name_cam)

    asset_templ_file =
      Path.join(["templates", "lib", "farmbot_res", "asset", "<%= snake %>.ex.eex"])

    migration_templ_file =
      Path.join([
        "templates",
        "priv",
        "repo",
        "migrations",
        "<%= timestamp %>_create_<%= plural %>_table.exs.eex"
      ])

    render_opts = [
      module_name: module,
      migration_module_name: migration_module_name,
      plural: plural_str,
      snake: module_snake
    ]

    asset_data = EEx.eval_file(asset_templ_file, render_opts)
    migration_data = EEx.eval_file(migration_templ_file, render_opts)
    out_file = Path.join(["lib", "farmbot_res", "asset", "#{module_snake}.ex"])

    :ok = Mix.Tasks.Ecto.Gen.Migration.run(["create_#{plural_str}_table"])

    migration_file_name =
      File.ls!(Path.join(["priv", "repo", "migrations"]))
      |> Enum.find(fn path ->
        case path do
          <<_::binary-size(14), "_create_", rest::binary>> ->
            String.contains?(rest, "#{plural_str}_table.exs")

          _ ->
            false
        end
      end) ||
        Mix.raise(
          "Coudl not find migration file: priv/repo/migrations/create_#{plural_str}_table.exs"
        )

    migration_file = Path.join(["priv", "repo", "migrations", migration_file_name])

    :ok = File.write!(migration_file, migration_data)
    :ok = File.write!(out_file, asset_data)
  end
end
