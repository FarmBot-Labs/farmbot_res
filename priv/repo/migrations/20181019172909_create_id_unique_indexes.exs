defmodule FarmbotRes.Repo.Migrations.CreateIdUniqueIndexes do
  use Ecto.Migration

  def change do
    create(unique_index("devices", :id))
    create(unique_index("tools", :id))
    create(unique_index("peripherals", :id))
    create(unique_index("sensors", :id))
    create(unique_index("sensor_readings", :id))
    create(unique_index("sequences", :id))
    create(unique_index("regimens", :id))
    create(unique_index("pin_bindings", :id))
    create(unique_index("points", :id))
    create(unique_index("farm_events", :id))
  end
end
