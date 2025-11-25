import Config

# For development, we disable any cache and enable debugging and code reloading.
config :phoenix_api, PhoenixApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dev_secret_key_base_that_is_at_least_64_bytes_long_for_development_only_do_not_use_in_prod",
  watchers: []

# Configure API keys for development
# In development, you can use these test keys
config :phoenix_api, :api_keys, [
  "dev-api-key-12345",
  "test-api-key-67890"
]

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"
