import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# application starts, so it is typically used to load production config
# and secrets from environment variables or elsewhere.

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "localhost"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :phoenix_api, PhoenixApiWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # Configure API keys from environment variable in production
  # Set API_KEYS as comma-separated values: API_KEYS=key1,key2,key3
  api_keys =
    case System.get_env("API_KEYS") do
      nil ->
        raise """
        environment variable API_KEYS is missing.
        Please set API_KEYS with comma-separated API keys.
        Example: API_KEYS=mykey1,mykey2
        """

      keys ->
        String.split(keys, ",", trim: true)
    end

  config :phoenix_api, :api_keys, api_keys
end
