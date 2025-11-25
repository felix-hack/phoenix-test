defmodule PhoenixApiWeb.ProtectedController do
  use PhoenixApiWeb, :controller

  @doc """
  A simple protected endpoint that requires API key authentication.
  """
  def index(conn, _params) do
    json(conn, %{
      status: "authenticated",
      message: "You have successfully accessed a protected endpoint"
    })
  end

  @doc """
  Returns sample data. Requires API key authentication.
  """
  def data(conn, _params) do
    json(conn, %{
      data: [
        %{id: 1, name: "Item 1", description: "First item"},
        %{id: 2, name: "Item 2", description: "Second item"},
        %{id: 3, name: "Item 3", description: "Third item"}
      ],
      metadata: %{
        total: 3,
        api_key_used: conn.assigns[:api_key] |> mask_api_key()
      }
    })
  end

  defp mask_api_key(nil), do: "***"
  defp mask_api_key(key) when byte_size(key) <= 8, do: "***"
  defp mask_api_key(key) do
    prefix = String.slice(key, 0, 4)
    "#{prefix}***"
  end
end
