defmodule PhoenixApiWeb.HealthController do
  use PhoenixApiWeb, :controller

  @doc """
  Health check endpoint. No authentication required.
  """
  def index(conn, _params) do
    json(conn, %{status: "ok", message: "API is running"})
  end
end
