defmodule Metrics.Instrumenter do
  use Prometheus.Metric
  alias Prometheus.Metric.{Counter, Histogram, Gauge}
  require Logger
end
