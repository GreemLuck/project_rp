# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :project_rp,
  ecto_repos: [ProjectRp.Repo]

# Configures the endpoint
config :project_rp, ProjectRpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "itQpWS4C79rkpJru7F9YIpVaJdBKocaY6HH0T8dYibOW21f52fIKl1wd3pX6vpPW",
  render_errors: [view: ProjectRpWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ProjectRp.PubSub,
  live_view: [signing_salt: "ibeKOXQ5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
