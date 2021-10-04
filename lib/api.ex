defmodule Pinata.API do
  use Tesla

  adapter Tesla.Adapter.Mint, timeout: 60_000
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, "https://api.pinata.cloud/"
  plug Tesla.Middleware.Headers, auth_headers()

  defp auth_headers() do
    [
      {"pinata_api_key", "14a4b61b56a77cba47fe"},
      {"pinata_secret_api_key", "dbe47c4441fdfedcbdbb20874d8a410a3f0094d6ad2c2dcefb039c45b1c8828a"},
    ]
  end
end
