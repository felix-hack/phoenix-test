defmodule PhoenixApiWeb.HealthControllerTest do
  use PhoenixApiWeb.ConnCase

  describe "GET /api/health" do
    test "returns health status without authentication", %{conn: conn} do
      conn = get(conn, "/api/health")

      assert json_response(conn, 200) == %{
               "status" => "ok",
               "message" => "API is running"
             }
    end
  end
end
