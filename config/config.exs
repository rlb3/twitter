# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitter,
  ecto_repos: [Twitter.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :twitter, TwitterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v0XjDzZmDab+XsqRVNgXyAq/kgIMoSr8DTD8yQaxH7a/5D8eAAOSTPSNGOU5GYsx",
  render_errors: [view: TwitterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Twitter.PubSub,
  live_view: [signing_salt: "6Ib2jJ8X"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :twitter, :pow,
  user: Twitter.Users.User,
  repo: Twitter.Repo,
  web_module: TwitterWeb

config :twitter, :pow_assent,
  providers: [
    github: [
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      strategy: Assent.Strategy.Github
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
