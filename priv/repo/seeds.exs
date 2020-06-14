# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DailyDadJokes.Repo.insert!(%DailyDadJokes.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias DailyDadJokes.Repo
alias DailyDadJokes.Core.Subscriber

[
  # Me
  %{
    phone_number: "+19402179962",
    time_of_day: 9,
    time_zone: "America/Chicago",
    verified_at: NaiveDateTime.utc_now()
  },
  # Google Voice (unverified)
  %{
    phone_number: "+19402684073",
    time_of_day: 9,
    time_zone: "America/Chicago"
  },
  # Abigail
  %{
    phone_number: "+19402221216",
    time_of_day: 11,
    time_zone: "America/Chicago",
    verified_at: NaiveDateTime.utc_now()
  },
  # Ashton
  %{
    phone_number: "+19403957020",
    time_of_day: 13,
    time_zone: "America/Chicago",
    verified_at: NaiveDateTime.utc_now()
  }
]
|> Enum.each(fn subscriber ->
  Subscriber.changeset(subscriber)
  |> Repo.insert!()
end)
