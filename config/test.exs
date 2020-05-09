use Mix.Config

# Configure your database
config :daily_dad_jokes, DailyDadJokes.Repo,
  username: "postgres",
  password: "postgres",
  database: "daily_dad_jokes_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :daily_dad_jokes, DailyDadJokesWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
