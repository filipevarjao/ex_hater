defmodule TT.Application do
  use Application

  def start(_, _) do
    require Prometheus.Registry
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    Metrics.Exporter.setup()

    children = []

    options = [strategy: :one_for_one, name: TT.Supervisor]
    Supervisor.start_link(children, options)
  end
end
