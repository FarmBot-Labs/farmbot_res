defmodule FarmbotRes.API do
  alias FarmbotRes.API
  use Tesla

  # localhost
  @token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwic3ViIjoxLCJpYXQiOjE1NDAyMjIwODUsImp0aSI6IjBlNzQyNzY5LTI5N2EtNGQwNi1iZGQzLWYxNWE1NTUzNzFjMCIsImlzcyI6Ii8vMTkyLjE2OC44Ni40NjozMDAwIiwiZXhwIjoxNTQzNjc4MDg0LCJtcXR0IjoiMTkyLjE2OC44Ni40NiIsImJvdCI6ImRldmljZV8yIiwidmhvc3QiOiIvIiwibXF0dF93cyI6IndzOi8vMTkyLjE2OC44Ni40NjozMDAyL3dzIiwib3NfdXBkYXRlX3NlcnZlciI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvZmFybWJvdC9mYXJtYm90X29zL3JlbGVhc2VzL2xhdGVzdCIsImZ3X3VwZGF0ZV9zZXJ2ZXIiOiJERVBSRUNBVEVEIiwiaW50ZXJpbV9lbWFpbCI6InRlc3RAdGVzdC5jb20iLCJiZXRhX29zX3VwZGF0ZV9zZXJ2ZXIiOiJodHRwczovL2FwaS5naXRodWIuY29tL3JlcG9zL0Zhcm1Cb3QvZmFybWJvdF9vcy9yZWxlYXNlcy9sYXRlc3QifQ.4J90e_K98Nohd-OQKafdGYF-5BY7IFJFZMi0tzmmItOupkjgoRcEn6zLtxVqrhuqtsfZoEsfk3hBlfmZXo46E5cjlkQ0v1Rf6l2HdqL3euOKK_SybxpMGvJBROq7HrGDhGejyB0LwNZV__Top0fABG9r4GON0R1U-o6RjbmEtTqjBWAIvXWeaQuMV0ye0ehwiZXP2akdxVGI_gFbSZ9-sOSux5wmgZ7kug9TU8qA_ChEioFQN5wLn4wouio7L16r0ON64xM2sMI0gxJSfyjs25o5arognNJpnNvS2L9v7CJqRnvTSTV9RoINCEWpHLU9yhqOZBUPNFx8XxSpjgKcGg"

  # Staging
  # @token "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ1bmtub3duIiwic3ViIjo2LCJpYXQiOjE1NDAzMjg5MTIsImp0aSI6IjI5MDNmZGZjLWFiMjItNDk4ZS04MWYxLTExY2Y0ZTI4NGU4ZiIsImlzcyI6Ii8vc3RhZ2luZy5mYXJtYm90LmlvOjQ0MyIsImV4cCI6MTU0Mzc4NDkxMCwibXF0dCI6InNwaXJpdGVkLWNyb3cucm1xLmNsb3VkYW1xcC5jb20iLCJib3QiOiJkZXZpY2VfNiIsInZob3N0Ijoic3p4b3NzZXgiLCJtcXR0X3dzIjoid3NzOi8vc3Bpcml0ZWQtY3Jvdy5ybXEuY2xvdWRhbXFwLmNvbTo0NDMvd3MvbXF0dCIsIm9zX3VwZGF0ZV9zZXJ2ZXIiOiJodHRwczovL2FwaS5naXRodWIuY29tL3JlcG9zL2Zhcm1ib3QvZmFybWJvdF9vcy9yZWxlYXNlcy9sYXRlc3QiLCJmd191cGRhdGVfc2VydmVyIjoiREVQUkVDQVRFRCIsImludGVyaW1fZW1haWwiOiJjb25ub3JAZmFybWJvdC5pbyIsImJldGFfb3NfdXBkYXRlX3NlcnZlciI6Imh0dHBzOi8vYXBpLmdpdGh1Yi5jb20vcmVwb3MvRmFybUJvdC9mYXJtYm90X29zL3JlbGVhc2VzLzEzMjcyMjg2In0.BN6tfuBd7oxJRlSZNg5s9g1J0XKYeDfVFA1IDP0uLRl7WcjgawLiToMIy2KniWcHqqYQDvq8yfjznv7fEDAJEGhNTx_M0bnJIh5UgOCikCVnq37oKnwHgk5okIBxlv-ayrU-RSE1pJyRdAaJDmvWi7uU_ts6tjZQcc6-i5efW_qEbdFRYBEUgESr0yAyOBGd26XDn5PptDriAaLXOKXsXWXDFuPA9ONs7lYW12XAjHztmoBxUDWKBaxhFqCR4x6pjGKsOf-nmuqPzRuxuqpupbCtYAdPMTO4hCBeelS3bJG0ljMHW7U9dyP54T3QIATDvRqkWv9ff18Km2lDuSQveA"
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.FollowRedirects)
  # plug(Tesla.Middleware.Logger)

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
  def get_changeset(module) when is_atom(module) do
    get_changeset(struct(module))
  end

  def get_changeset(%module{} = data) do
    get_body!(module.path())
    |> case do
      %{} = single ->
        module.changeset(data, single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(data, &1))
    end
  end

  @doc "helper for `GET`ing api resources."
  def get_changeset(asset, path)

  # Hacks for dealing with these resources not having #show
  def get_changeset(FarmbotRes.Asset.FbosConfig, _),
    do: get_changeset(FarmbotRes.Asset.FbosConfig)

  def get_changeset(FarmbotRes.Asset.FirmwareConfig, _),
    do: get_changeset(FarmbotRes.Asset.FirmwareConfig)

  def get_changeset(%FarmbotRes.Asset.FbosConfig{} = data, _),
    do: get_changeset(data)

  def get_changeset(%FarmbotRes.Asset.FirmwareConfig{} = data, _),
    do: get_changeset(data)

  def get_changeset(module, path) when is_atom(module) do
    get_changeset(struct(module), path)
  end

  def get_changeset(%module{} = data, path) do
    get_body!(Path.join(module.path(), to_string(path)))
    |> case do
      %{} = single ->
        module.changeset(data, single)

      many when is_list(many) ->
        Enum.map(many, &module.changeset(data, &1))
    end
  end
end
