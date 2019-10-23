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
      ),
      %{
        id: TT.Server,
        start: {TT.Server, :start_link, []},
        restart: :permanent,
        shutdown: 5000,
        type: :worker
      }
    ]

    options = [strategy: :one_for_one, name: TT.Supervisor]
    Supervisor.start_link(children, options)
  end
end
