defmodule Rewizard.MixProject do
  use Mix.Project

  def project do
    [
      app: :rewizard,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Rewizard.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, github: "Kraigie/nostrum", override: true},
      {:nosedrum, "~> 0.2"},
      {:ecto3_mnesia, "~> 0.2.1"},
      {:hammer, "~> 6.0"},
    ]
  end
end
