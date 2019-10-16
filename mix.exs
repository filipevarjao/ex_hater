defmodule ExHater.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_hater,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :extwitter],
      mod: {TT.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oauther, "~> 1.1"},
      {:extwitter, "~> 0.8"},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 3.0"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"}
    ]
  end
end
