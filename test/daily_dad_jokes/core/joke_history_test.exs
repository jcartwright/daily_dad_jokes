defmodule DailyDadJokes.Core.JokeHistoryTest do
  use DailyDadJokes.DataCase, async: true

  alias DailyDadJokes.Core.JokeHistory

  setup do
    joke_history =
      [
        %{
          joke_id: "212",
          setup: "What do you call a dog that can do magic tricks?",
          punchline: "a labracadabrador",
          sent_on: NaiveDateTime.utc_now() |> Timex.shift(months: -12, days: -1),
          recipient_count: 5,
          type: "general"
        },
        %{
          joke_id: "193",
          setup: "What did the Red light say to the Green light?",
          punchline: "Don't look at me I'm changing!",
          sent_on: NaiveDateTime.utc_now() |> Timex.shift(months: -6),
          recipient_count: 15,
          type: "general"
        },
        %{
          joke_id: "93",
          setup: "Did you hear about the Mexican train killer?",
          punchline: "He had loco motives",
          sent_on: NaiveDateTime.utc_now() |> Timex.shift(days: -1),
          recipient_count: 25,
          type: "general"
        }
      ]
      |> Enum.map(fn attrs -> JokeHistory.changeset(attrs) |> Repo.insert!() end)

    [joke_history: joke_history]
  end

  test "unused_joke_ids_since/2" do
    last_year = Timex.now() |> Timex.shift(years: -1)
    candidate_ids = ["212", "193", "93", "999"]

    assert ["212", "999"] == JokeHistory.unused_joke_ids_since(candidate_ids, last_year)
  end

  test "used_on/2" do
    yesterday = Timex.now() |> Timex.shift(days: -1)

    assert %JokeHistory{} =
             JokeHistory.used_on(yesterday)
             |> Repo.one()
  end
end
