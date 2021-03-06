# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :spider_man_ui, SpiderManUiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TIXSBhy+pFMvh5WJz6P67kAbwcC4WxpSMfbIUtYCKNCNk9B672NMNKxs+OY4CXwo",
  render_errors: [view: SpiderManUiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SpiderManUi.PubSub,
  live_view: [signing_salt: "S1RRWtUT"]

# Livebook configuration
config :livebook, LivebookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Lw7uycHu3bAv0sQE05mJm6q/ANjvtex9jHg1eTxUw+9dTRwPthb1gBGVxKZanXwU",
  pubsub_server: Livebook.PubSub,
  live_view: [signing_salt: "Mx2KO7mY"]

config :livebook,
  default_runtime: Livebook.Runtime.Embedded,
  authentication_mode: :disabled,
  token_authentication: false,
  root_path: ".",
  cookie: :spider_man_ui

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
