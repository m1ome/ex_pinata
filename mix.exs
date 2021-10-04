defmodule Pinata.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pinata,
      version: "1.0.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/m1ome/ex_pinata",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.4.0"},
      {:timex, "~> 3.7"},
      {:mint, "~> 1.0"},
      {:castore, "~> 0.1"},
      {:jason, "~> 1.2"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp description do
    "Elixir provider for pinata.cloud IPFS service"
  end

  defp package do
    [
      name: "ex_pinata",
      files: ~w(lib mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/m1ome/ex_pinata"}
    ]
  end
end
