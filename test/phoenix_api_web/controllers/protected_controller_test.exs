defmodule PhoenixApiWeb.ProtectedControllerTest do
  use PhoenixApiWeb.ConnCase

  describe "GET /api/protected" do
    test "returns success with valid API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-valid-api-key")
        |> get("/api/protected")

      assert json_response(conn, 200) == %{
               "status" => "authenticated",
               "message" => "You have successfully accessed a protected endpoint"
             }
    end

    test "returns 401 without API key", %{conn: conn} do
      conn = get(conn, "/api/protected")

      assert json_response(conn, 401) == %{"error" => "Missing API key"}
    end

    test "returns 401 with invalid API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "invalid-key")
        |> get("/api/protected")

      assert json_response(conn, 401) == %{"error" => "Invalid API key"}
    end
  end

  describe "GET /api/protected/data" do
    test "returns data with valid API key via x-api-key header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-valid-api-key")
        |> get("/api/protected/data")

      response = json_response(conn, 200)
      assert is_list(response["data"])
      assert length(response["data"]) == 3
      assert response["metadata"]["total"] == 3
    end

    test "returns data with valid API key via Bearer token", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer test-valid-api-key")
        |> get("/api/protected/data")

      response = json_response(conn, 200)
      assert is_list(response["data"])
      assert length(response["data"]) == 3
    end

    test "returns 401 without API key", %{conn: conn} do
      conn = get(conn, "/api/protected/data")

      assert json_response(conn, 401) == %{"error" => "Missing API key"}
    end
  end
end
