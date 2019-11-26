defmodule ExHater.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_hater,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Testing
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :extwitter, :prometheus_ex, :cowboy],
      mod: {TT.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # twitter API
      {:oauther, "~> 1.1"},
      {:extwitter, "~> 0.8"},
      # metrics
      {:plug_cowboy, "~> 2.1.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1.5"},
      {:prometheus_process_collector, "~> 1.4"},
      {:poison, "~> 3.0"},
      # watson API
      {:ex_watson_tone, git: "https://github.com/filipevarjao/ex_watson_tone.git"},
      # Test
      {:excoveralls, "~> 0.9", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/"]
  defp elixirc_paths(_), do: ["lib"]
end
