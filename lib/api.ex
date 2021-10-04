defmodule Pinata.API do
  use Tesla

  adapter(Tesla.Adapter.Mint, timeout: 120_000)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.BaseUrl, "https://api.pinata.cloud/")
  plug(Tesla.Middleware.Headers, auth_headers())

  defp auth_headers() do
    [
      {"pinata_api_key", api_key()},
      {"pinata_secret_api_key", api_token()}
    ]
  end

  defp api_key(), do: Application.get_env(:pinata, :api_key) || ""
  defp api_token(), do: Application.get_env(:pinata, :api_token) || ""
end
