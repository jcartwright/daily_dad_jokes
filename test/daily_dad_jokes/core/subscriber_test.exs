defmodule DailyDadJokes.Core.SubscriberTest do
  use DailyDadJokes.DataCase, async: true

  alias DailyDadJokes.Core.Subscriber

  setup do
    subscribers =
      [
        %{
          phone_number: "+19402179962",
          time_of_day: 9,
          time_zone: "America/Chicago",
          verified_at: Timex.now() |> Timex.shift(weeks: -1)
        },
        %{
          phone_number: "+19402684073",
          time_of_day: 9,
          time_zone: "America/Chicago",
          verified_at: nil
        },
        %{
          phone_number: "+19402221216",
          time_of_day: 11,
          time_zone: "America/Chicago",
          verified_at: Timex.now() |> Timex.shift(weeks: -1)
        },
        %{
          phone_number: "+19403957020",
          time_of_day: 13,
          time_zone: "America/Chicago",
          verified_at: Timex.now() |> Timex.shift(weeks: -1),
          unsubscribed_at: Timex.now()
        }
      ]
      |> Enum.map(fn attrs -> Subscriber.changeset(attrs) |> Repo.insert!() end)

    [subscribers: subscribers]
  end

  test "verified/1 returns only verified subscribers" do
    verified =
      Subscriber.verified()
      |> Repo.all()

    refute Enum.empty?(verified)
    assert Enum.all?(verified, &(is_nil(&1.verified_at) == false))
    assert Enum.all?(verified, &(is_nil(&1.unsubscribed_at)))
  end

  test "at_time_of_day/2 returns subscribers matching time_of_day" do
    time_of_day = 9
    at_time_of_day =
      Subscriber.at_time_of_day(time_of_day)
      |> Repo.all()

    refute Enum.empty?(at_time_of_day)
    assert Enum.all?(at_time_of_day, &(&1.time_of_day == time_of_day))
  end

  test "in_time_zone/2 returns subscribers matching time_zone" do
    time_zone = "America/Chicago"
    in_time_zone =
      Subscriber.in_time_zone(time_zone)
      |> Repo.all()

    refute Enum.empty?(in_time_zone)
    assert Enum.all?(in_time_zone, &(&1.time_zone == time_zone))
  end
end
