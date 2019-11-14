defmodule Metrics.Instrumenter do
  use Prometheus.Metric

  alias Prometheus.Metric.Counter

  require Logger

  @counter [
    name: :like,
    help: "counter incremeted for every like",
    labels: [:target]
  ]

  def like(favorited) do
    Counter.inc(
      name: :like,
      labels: [favorited]
    )
  end
end
