defmodule Plug.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(Metrics.Exporter)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end
end
