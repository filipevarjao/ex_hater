defmodule Plug.Endpoint do
  import Plug.Conn

  alias Plug.Templates
  alias TT.Server

  def init(%{}), do: true

  def call(%Plug.Conn{request_path: route, method: "GET"} = conn, _opts) do
    case route do
      "/timeline" ->
        state = TT.Server.get_state()

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, Templates.timeline(state))

      "/list" ->
        content = TT.Server.get_data()

        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, Templates.list(content))

      "/upload" ->
        conn
        |> put_resp_content_type("text/html")
        |> send_resp(200, Templates.upload_html())

      some ->
        case String.split(some, "/", trim: true) do
          ["show", id] ->
            content = TT.Server.show(id)

            conn
            |> put_resp_content_type("text/plain")
            # magic number, six is the position at mensia table
            |> send_resp(200, Enum.at(content, 6))

          ["tone", id] ->
            TT.Server.tone(id)

            conn
            |> resp(:found, "")
            |> put_resp_header("location", "/list")

          _ ->
            conn
            |> resp(:found, "")
            |> put_resp_header("location", "/list")
        end
    end
  end

  def call(
        %Plug.Conn{
          request_path: route,
          method: "POST",
          adapter: {_, %{body_length: body_length, headers: headers}}
        } = conn,
        _opts
      ) do
    case route do
      "/upload" ->
        {:ok, body, _conn} = Plug.Conn.read_body(conn, length: body_length)
        content = parse_multdata(body, headers)
        Server.tone_analyze(content)

        conn
        |> resp(:found, "")
        |> put_resp_header("location", "/list")

      _ ->
        send_resp(conn, 404, "oops... Nothing here :(")
    end
  end

  defp parse_multdata(text, %{"content-type" => type} = _headers) do
    boundary =
      type
      |> String.split("=")
      |> List.last()

    text
    |> String.replace(boundary, "")
    |> String.replace("-", "")
    |> String.split("application/json")
    |> List.last()
  end
end
