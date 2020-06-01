# https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-runtime-configuration
import Config

database_url = System.fetch_env!("DATABASE_URL")
secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
port = System.fetch_env!("PORT")

config :daily_dad_jokes, DailyDadJokes.Repo,
  url: database_url

config :daily_dad_jokes, DailyDadJokes.Endpoint,
  http: [port: port],
  secret_key_base: secret_key_base,
  url: [host: {:system, "APP_HOST"}, port: {:system, "PORT"}]

# Other runtime configuration...
