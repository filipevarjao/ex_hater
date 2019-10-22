defmodule TT.Application do
  use Application

  def start(_, _) do
    require Prometheus.Registry
    Prometheus.Registry.register_collector(:prometheus_process_collector)
    Metrics.Exporter.setup()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Plug.Pipeline,
        options: [port: 4001],
        server: true
      )
    ]

    options = [strategy: :one_for_one, name: TT.Supervisor]
    Supervisor.start_link(children, options)
  end
end
