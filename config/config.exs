# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :daily_dad_jokes,
  ecto_repos: [DailyDadJokes.Repo],
  generators: [binary_id: true],
  jokester: DailyDadJokes.Jokester,
  jokes_api: DailyDadJokes.Api.DadJokes,
  sms_gateway: DailyDadJokes.Api.Messagebird

# Configures the endpoint
config :daily_dad_jokes, DailyDadJokesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xEky+Zff8aFKhsmrygu5ss4mk59HxaVKG76nlTem/c/cMqd5oUNZBHuZiNjEWIvO",
  render_errors: [view: DailyDadJokesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DailyDadJokes.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
