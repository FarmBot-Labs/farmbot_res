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

  @token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwic3ViIjoxLCJpYXQiOjE1NDAyMjIwODUsImp0aSI6IjBlNzQyNzY5LTI5N2EtNGQwNi1iZGQzLWYxNWE1NTUzNzFjMCIsImlzcyI6Ii8vMTkyLjE2OC44Ni40NjozMDAwIiwiZXhwIjoxNTQzNjc4MDg0LCJtcXR0IjoiMTkyLjE2OC44Ni40NiIsImJvdCI6ImRldmljZV8yIiwidmhvc3QiOiIvIiwibXF0dF93cyI6IndzOi8vMTkyLjE2OC44Ni40NjozMDAyL3dzIiwib3NfdXBkYXRlX3NlcnZlciI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvZmFybWJvdC9mYXJtYm90X29zL3JlbGVhc2VzL2xhdGVzdCIsImZ3X3VwZGF0ZV9zZXJ2ZXIiOiJERVBSRUNBVEVEIiwiaW50ZXJpbV9lbWFpbCI6InRlc3RAdGVzdC5jb20iLCJiZXRhX29zX3VwZGF0ZV9zZXJ2ZXIiOiJodHRwczovL2FwaS5naXRodWIuY29tL3JlcG9zL0Zhcm1Cb3QvZmFybWJvdF9vcy9yZWxlYXNlcy9sYXRlc3QifQ.4J90e_K98Nohd-OQKafdGYF-5BY7IFJFZMi0tzmmItOupkjgoRcEn6zLtxVqrhuqtsfZoEsfk3hBlfmZXo46E5cjlkQ0v1Rf6l2HdqL3euOKK_SybxpMGvJBROq7HrGDhGejyB0LwNZV__Top0fABG9r4GON0R1U-o6RjbmEtTqjBWAIvXWeaQuMV0ye0ehwiZXP2akdxVGI_gFbSZ9-sOSux5wmgZ7kug9TU8qA_ChEioFQN5wLn4wouio7L16r0ON64xM2sMI0gxJSfyjs25o5arognNJpnNvS2L9v7CJqRnvTSTV9RoINCEWpHLU9yhqOZBUPNFx8XxSpjgKcGg"
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
