defmodule PhoenixApiWeb.Router do
  use PhoenixApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug PhoenixApiWeb.Plugs.ApiKeyAuth
  end

  # Public endpoints (no authentication required)
  scope "/api", PhoenixApiWeb do
    pipe_through :api

    get "/health", HealthController, :index
  end

  # Protected endpoints (API key required)
  scope "/api", PhoenixApiWeb do
    pipe_through :api_auth

    get "/protected", ProtectedController, :index
    get "/protected/data", ProtectedController, :data
  end
end
