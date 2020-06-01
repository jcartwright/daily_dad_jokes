defmodule DailyDadJokes.Repo do
  use Ecto.Repo,
    otp_app: :daily_dad_jokes,
    adapter: Ecto.Adapters.Postgres
  use Ecto.Explain
end
