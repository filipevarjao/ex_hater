defmodule Plug.Endpoint do
  import Plug.Conn

  def init(%{}), do: true

  def call(%Plug.Conn{request_path: route} = conn, _opts) do
    case route do
      "/ping" ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "pong")
        |> halt()

      _ ->
        send_resp(conn, 404, "oops... Nothing here :(")
    end
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
