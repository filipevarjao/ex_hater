defmodule ExHater.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_hater,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ex_watson_tone, git: "https://github.com/filipevarjao/ex_watson_tone.git"}
    ]
  end
end
