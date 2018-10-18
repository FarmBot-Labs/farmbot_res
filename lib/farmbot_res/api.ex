defmodule FarmbotRes.API do
  alias FarmbotRes.API

  alias FarmbotRes.Asset.{
    Device,
    Peripheral,
    PinBinding,
    Regimen,
    Sensor,
    SensorReading,
    Sequence,
    Tool
  }

  use Tesla

  @token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwic3ViIjoxLCJpYXQiOjE1Mzk4MDEzODgsImp0aSI6ImYwNmU3YWViLTM0ZjUtNDM1OS1iMTI4LTc2OTc5YWFmMmRlZCIsImlzcyI6Ii8vMTkyLjE2OC4xLjY4OjMwMDAiLCJleHAiOjE1NDMxNzMwODgsIm1xdHQiOiIxOTIuMTY4LjEuNjgiLCJib3QiOiJkZXZpY2VfMiIsInZob3N0IjoiLyIsIm1xdHRfd3MiOiJ3czovLzE5Mi4xNjguMS42ODozMDAyL3dzIiwib3NfdXBkYXRlX3NlcnZlciI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvZmFybWJvdC9mYXJtYm90X29zL3JlbGVhc2VzL2xhdGVzdCIsImZ3X3VwZGF0ZV9zZXJ2ZXIiOiJERVBSRUNBVEVEIiwiaW50ZXJpbV9lbWFpbCI6InRlc3RAdGVzdC5jb20iLCJiZXRhX29zX3VwZGF0ZV9zZXJ2ZXIiOiJodHRwczovL2FwaS5naXRodWIuY29tL3JlcG9zL0Zhcm1Cb3QvZmFybWJvdF9vcy9yZWxlYXNlcy9sYXRlc3QifQ.E_B_41buacdSOVymlkHV8AWabMUwGlOlFqhSTwaY8Vv8gukdz793gkeksW7yIFJfW4yDdJmPM02Jwr7-66NvieublibFyRopYebicmowvA2CKSEzXU_IT3LHSGQvM5_EpzDycWjMY08DqGHJ1L3wV6vHYf4LJWWOeXU6alsyLdX29KsfoxNnmwmrquiOoZQwUKnJX5xiJpezBnUGSVj-9sfM03yjFBd7tCavWprHsh8-QMBrEbkA-Z6rVQTKJhw9l2qixCkwouu1kuwcSagEsUIhjiSezc0Xxzd1dP8UQolzKVHFz-4FJeLM3wP-np2fB4tRKZsfV3P8fclUhlH12Q"

  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  @doc "GET a changeset for the Device endpoint"
  def device, do: get_changeset(Device)

  @doc "GET a changeset for all Tools"
  def tools, do: get_changeset(Tool)
  def tools(path), do: get_changeset(Tool, path)

  @doc "GET a changeset for all Peripherals"
  def peripherals, do: get_changeset(Peripheral)

  @doc "GET a changeset for all Sensors"
  def sensors, do: get_changeset(Sensor)

  @doc "GET a changeset for all SensorReadings"
  def sensor_readings, do: get_changeset(SensorReading)

  @doc "GET a changeset for all Sequences"
  def sequences, do: get_changeset(Sequence)
  def sequences(path), do: get_changeset(Sequence, path)

  @doc "GET a changeset for all Regimens"
  def regimens, do: get_changeset(Regimen)

  @doc "GET a changeset for all PinBindings"
  def pin_bindings, do: get_changeset(PinBinding)

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
         {"authorization", "Bearer: " <> @token},
         {"user-agent", "farmbot-res"}
       ]}
    ])
  end

  @doc "helper for `GET`ing api resources."
  def get_changeset(module) do
    client()
    |> API.get!(module.path())
    |> Map.fetch!(:body)
    |> case do
      %{} = single ->
        module.changeset(struct(module), single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(struct(module), &1))
    end
  end

  @doc "helper for `GET`ing api resources."
  def get_changeset(module, path) do
    client()
    |> API.get!(Path.join(module.path(), to_string(path)))
    |> Map.fetch!(:body)
    |> case do
      %{} = single ->
        module.changeset(struct(module), single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(struct(module), &1))
    end
  end
end
