defmodule PhoenixApiWeb.Plugs.ApiKeyAuth do
  @moduledoc """
  A Plug for API key authentication.

  This plug checks for a valid API key in the request headers.
  The API key can be provided via:
  - `x-api-key` header
  - `Authorization` header with `Bearer <api-key>` format

  ## Configuration

  Configure valid API keys in your config:

      config :phoenix_api, :api_keys, ["your-api-key-1", "your-api-key-2"]

  Or set the `API_KEYS` environment variable with comma-separated keys:

      API_KEYS=key1,key2,key3
  """

  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    with {:ok, api_key} <- get_api_key(conn),
         :ok <- validate_api_key(api_key) do
      conn
      |> assign(:api_key, api_key)
    else
      {:error, :missing_api_key} ->
        conn
        |> send_unauthorized_response("Missing API key")
        |> halt()

      {:error, :invalid_api_key} ->
        conn
        |> send_unauthorized_response("Invalid API key")
        |> halt()
    end
  end

  defp get_api_key(conn) do
    case get_req_header(conn, "x-api-key") do
      [api_key | _] ->
        {:ok, api_key}

      [] ->
        case get_req_header(conn, "authorization") do
          ["Bearer " <> api_key | _] ->
            {:ok, api_key}

          _ ->
            {:error, :missing_api_key}
        end
    end
  end

  defp validate_api_key(api_key) do
    valid_keys = get_valid_api_keys()

    if api_key in valid_keys do
      :ok
    else
      {:error, :invalid_api_key}
    end
  end

  defp get_valid_api_keys do
    case Application.get_env(:phoenix_api, :api_keys) do
      nil ->
        case System.get_env("API_KEYS") do
          nil -> []
          keys -> String.split(keys, ",", trim: true)
        end

      keys when is_list(keys) ->
        keys

      _ ->
        []
    end
  end

  defp send_unauthorized_response(conn, message) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: message}))
  end
end
