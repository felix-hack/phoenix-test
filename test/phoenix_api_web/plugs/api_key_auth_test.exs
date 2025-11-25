defmodule PhoenixApiWeb.Plugs.ApiKeyAuthTest do
  use PhoenixApiWeb.ConnCase

  alias PhoenixApiWeb.Plugs.ApiKeyAuth

  describe "API Key Authentication" do
    test "allows request with valid x-api-key header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-valid-api-key")
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      refute conn.halted
      assert conn.assigns[:api_key] == "test-valid-api-key"
    end

    test "allows request with valid Bearer token in Authorization header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer test-valid-api-key")
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      refute conn.halted
      assert conn.assigns[:api_key] == "test-valid-api-key"
    end

    test "rejects request with invalid API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "invalid-key")
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      assert conn.halted
      assert conn.status == 401
      assert Jason.decode!(conn.resp_body) == %{"error" => "Invalid API key"}
    end

    test "rejects request without API key", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      assert conn.halted
      assert conn.status == 401
      assert Jason.decode!(conn.resp_body) == %{"error" => "Missing API key"}
    end

    test "prefers x-api-key header over Authorization header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("x-api-key", "test-valid-api-key")
        |> put_req_header("authorization", "Bearer another-valid-key")
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      refute conn.halted
      # Should use x-api-key, not Authorization header
      assert conn.assigns[:api_key] == "test-valid-api-key"
    end

    test "rejects request with malformed Authorization header", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Basic some-token")
        |> put_req_header("content-type", "application/json")
        |> ApiKeyAuth.call([])

      assert conn.halted
      assert conn.status == 401
      assert Jason.decode!(conn.resp_body) == %{"error" => "Missing API key"}
    end
  end
end
