defmodule FarmbotRes.API do
  alias FarmbotRes.API

  alias FarmbotRes.Asset.{
    Device,
    DiagnosticDump,
    FarmEvent,
    FarmwareEnv,
    FarmwareInstallation,
    FbosConfig,
    FirmwareConfig,
    Peripheral,
    PinBinding,
    Point,
    Regimen,
    SensorReading,
    Sensor,
    Sequence,
    Sync,
    Tool
  }

  use Tesla

  @token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwic3ViIjoxLCJpYXQiOjE1NDAxNjkyMzEsImp0aSI6ImNkYTU1NmRhLTNiZGYtNGZmZC05YmIyLTM5ZTFkYmUzOGM0MCIsImlzcyI6Ii8vMTkyLjE2OC4xLjEyMzozMDAwIiwiZXhwIjoxNTQzNjI1MjIyLCJtcXR0IjoiMTkyLjE2OC4xLjEyMyIsImJvdCI6ImRldmljZV8yIiwidmhvc3QiOiIvIiwibXF0dF93cyI6IndzOi8vMTkyLjE2OC4xLjEyMzozMDAyL3dzIiwib3NfdXBkYXRlX3NlcnZlciI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvZmFybWJvdC9mYXJtYm90X29zL3JlbGVhc2VzL2xhdGVzdCIsImZ3X3VwZGF0ZV9zZXJ2ZXIiOiJERVBSRUNBVEVEIiwiaW50ZXJpbV9lbWFpbCI6InRlc3RAdGVzdC5jb20iLCJiZXRhX29zX3VwZGF0ZV9zZXJ2ZXIiOiJodHRwczovL2FwaS5naXRodWIuY29tL3JlcG9zL0Zhcm1Cb3QvZmFybWJvdF9vcy9yZWxlYXNlcy9sYXRlc3QifQ.k_XSQvoijjrFMKXoFM7vEtTUQFhBhMuXn9Om0aoiq0B9Qrk-6PMkJMbO-DRrobq1NTDjvk0MgN84IoeiqHbQeoCVYHFBEe8wQ4JRSdDFRNphsE7NSbTY_40cRqQ7xd2bKlWVoCcNcCBvNZe2YsO4tiTGZbYeHmYQQP9BUbJ5qbFwTogTxWI_hBBapqa0iV8gWcJyHe1IHgsB_J0Z8jmt7bVUUqg1CXJo9htUMOmAeqcNfK-udrbdfFTiHIteqLGpZvcw-y4kUe5YQhiNuNhq5Py5TM5zrr-jyXzXYp-g0yO4NnMsilLabDBsqDLBFlSu_NX62P-SUbVyxtQBIrSvyA"

  plug(Tesla.Middleware.JSON)
  # plug(Tesla.Middleware.Logger)

  @doc "GET a changeset for the Device"
  def device, do: get_changeset(Device)

  @doc "GET a changeset for all DiagnosticDump"
  def diagnostic_dumps, do: get_changeset(DiagnosticDump)

  @doc "GET a changeset for all FarmEvents"
  def farm_events, do: get_changeset(FarmEvent)

  @doc "GET a changeset for all FarmwareEnvs"
  def farmware_envs, do: get_changeset(FarmwareEnv)

  @doc "GET a changeset for all FarmwareInstallations"
  def farmware_installation, do: get_changeset(FarmwareInstallation)

  @doc "GET a changset for FbosConfig"
  def fbos_config, do: get_changeset(FbosConfig)

  @doc "GET a changset for FirmwareConfig"
  def firmware_config, do: get_changeset(FirmwareConfig)

  @doc "GET a changeset for all Peripherals"
  def peripherals, do: get_changeset(Peripheral)

  @doc "GET a changeset for all PinBindings"
  def pin_bindings, do: get_changeset(PinBinding)

  @doc "GET a changeset for all Points"
  def points, do: get_changeset(Point)
  def points(path), do: get_changeset(Point, path)

  @doc "GET a changeset for all Regimens"
  def regimens, do: get_changeset(Regimen)

  @doc "GET a changeset for all SensorReadings"
  def sensor_readings, do: get_changeset(SensorReading)

  @doc "GET a changeset for all Sensors"
  def sensors, do: get_changeset(Sensor)

  @doc "GET a changeset for all Sequences"
  def sequences, do: get_changeset(Sequence)
  def sequences(path), do: get_changeset(Sequence, path)

  def sync, do: get_changeset(Sync)

  @doc "GET a changeset for all Tools"
  def tools, do: get_changeset(Tool)
  def tools(path), do: get_changeset(Tool, path)

  @doc false
  def client do
    tkn =
      String.split(@token, ".")
      |> Enum.at(1)
      |> Base.decode64!(padding: false)
      |> Jason.decode!()

    uri = Map.fetch!(tkn, "iss") |> URI.parse()
    url = (uri.scheme || "http") <> "://" <> uri.host <> ":" <> to_string(uri.port)

    Tesla.build_client([
      {Tesla.Middleware.BaseUrl, url},
      {Tesla.Middleware.Headers,
       [
         {"content-type", "application/json"},
         {"authorization", "Bearer: " <> @token},
         {"user-agent", "farmbot-res"}
       ]}
    ])
  end

  @doc "helper for `GET`ing a path."
  def get_body!(path) do
    API.get!(API.client(), path)
    |> Map.fetch!(:body)
  end

  @doc "helper for `GET`ing api resources."
  def get_changeset(module) do
    get_body!(module.path())
    |> case do
      %{} = single ->
        module.changeset(struct(module), single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(struct(module), &1))
    end
  end

  @doc "helper for `GET`ing api resources."
  def get_changeset(module, path) do
    get_body!(Path.join(module.path(), to_string(path)))
    |> case do
      %{} = single ->
        module.changeset(struct(module), single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(struct(module), &1))
    end
  end
end
