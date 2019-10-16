defmodule TT.Application do
  use Application

  def start(_, _) do
    TT.MetricsExporter.setup()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: TT.Endpoint,
        options: [port: 4001]
      )
    ]

    options = [strategy: :one_for_one, name: TT.Supervisor]
    Supervisor.start_link(children, options)
  end
end
