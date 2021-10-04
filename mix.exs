defmodule Pinata.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_pinata,
      version: "1.0.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
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
      {:jason, "~> 1.2"}
    ]
  end
end
