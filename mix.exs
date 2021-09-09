defmodule SpiderManUi.MixProject do
  use Mix.Project

  def project do
    [
      app: :spider_man_ui,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SpiderManUi.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5"},
      {:phoenix_live_view, "~> 0.16"},
      {:floki, "~> 0.30"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:circular_buffer, "~> 0.3.0"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:livebook, "~> 0.1"},
      {:spider_man, "~> 0.4"},
      {:logger_file_backend, "~> 0.0.11"},
      {:broadway_dashboard, "~> 0.2"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"]
    ]
  end
end
