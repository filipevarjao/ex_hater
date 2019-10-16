defmodule TT.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(TT.MetricsExporter)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

end
