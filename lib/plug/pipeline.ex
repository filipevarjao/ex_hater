defmodule Plug.Pipeline do
  use Plug.Builder
  plug(Plug.Logger)
  plug(Metrics.Exporter, %{})
end
