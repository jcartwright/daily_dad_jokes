# https://hexdocs.pm/mix/Mix.Tasks.Release.html#module-runtime-configuration
import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

pg_user = System.fetch_env!("POSTGRES_USER")
pg_pass = System.fetch_env!("POSTGRES_PASSWORD")
pg_database = System.fetch_env!("POSTGRES_DB")

pg_pool_size =
  System.fetch_env!("POSTGRES_POOL_SIZE")
  |> Integer.parse()
  |> case do
    {value, _} -> value
    :error -> raise ArgumentError, message: "Invalid value for POSTGRES_POOL_SIZE"
  end

port =
  System.fetch_env!("PORT")
  |> Integer.parse()
  |> case do
    {value, _} -> value
    :error -> raise ArgumentError, message: "Invalid value for PORT"
  end

config :daily_dad_jokes, DailyDadJokes.Repo,
  username: pg_user,
  password: pg_pass,
  database: pg_database,
  pool_size: pg_pool_size,
  show_sensitive_data_on_connection_error: false

config :daily_dad_jokes, DailyDadJokes.Endpoint,
  http: [port: port],
  secret_key_base: secret_key_base,
  url: [host: {:system, "APP_HOST"}, port: {:system, "PORT"}]

# Other runtime configuration...
