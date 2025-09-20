defmodule Discountex.MixProject do
  use Mix.Project

  def project do
    [
      app: :discountex,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # Using simpler HTTP client that's more likely to work in this environment
      # {:httpoison, "~> 2.0"},
      # {:floki, "~> 0.34.0"}
    ]
  end
end