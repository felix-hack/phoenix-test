defmodule PhoenixApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_api,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {PhoenixApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, github: "phoenixframework/phoenix", tag: "v1.7.14"},
      {:plug_cowboy, github: "elixir-plug/plug_cowboy", tag: "v2.7.2", override: true},
      {:jason, github: "michalmuskala/jason", tag: "v1.4.4", override: true},
      {:telemetry, github: "beam-telemetry/telemetry", tag: "v1.2.1", override: true},
      {:telemetry_metrics, github: "beam-telemetry/telemetry_metrics", tag: "v1.0.0", override: true},
      {:phoenix_pubsub, github: "phoenixframework/phoenix_pubsub", tag: "v2.1.3", override: true},
      {:plug, github: "elixir-plug/plug", tag: "v1.16.1", override: true},
      {:plug_crypto, github: "elixir-plug/plug_crypto", tag: "v2.1.0", override: true},
      {:websock_adapter, github: "phoenixframework/websock_adapter", tag: "0.5.5", override: true},
      {:phoenix_template, github: "phoenixframework/phoenix_template", tag: "v1.0.4", override: true},
      {:phoenix_html, github: "phoenixframework/phoenix_html", tag: "v4.1.1", override: true},
      {:websock, github: "phoenixframework/websock", tag: "0.5.3", override: true},
      {:mime, github: "elixir-plug/mime", tag: "v2.0.6", override: true},
      {:cowboy, github: "ninenines/cowboy", tag: "2.12.0", override: true},
      {:cowlib, github: "ninenines/cowlib", tag: "2.13.0", override: true},
      {:ranch, github: "ninenines/ranch", tag: "1.8.0", override: true},
      {:cowboy_telemetry, github: "beam-telemetry/cowboy_telemetry", tag: "v0.4.0", override: true},
      {:castore, github: "elixir-mint/castore", tag: "v1.0.8", override: true}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"]
    ]
  end
end
