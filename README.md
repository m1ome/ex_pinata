# Pinata 🪅
Adapter for [pinata.cloud](https://www.pinata.cloud/)

## Installation

```elixir
def deps do
  [
    {:ex_pinata, "~> 1.0.0"}
  ]
end
```

To start using adapter you should provide config:
```elixir
config :pinata,
  api_key: "YOUR_PINATA_API_KEY",
  api_token: "YOUR_PINATA_API_KEY
```

## Usage 
```elixir
content = File.read!("/path/to/some/file")
{:ok, file} = Pinata.pin_file(content, "my_file")
```