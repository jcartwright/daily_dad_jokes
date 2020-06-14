defmodule DailyDadJokes do
  @moduledoc """
  DailyDadJokes keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  require Logger
  @logger_prefix "[daily-dad-jokes]"

  alias DailyDadJokes.Core.{Joke, JokeHistory, Subscriber}
  alias DailyDadJokes.Repo

  def find_or_create_joke_of_the_day do
    Logger.debug("#{@logger_prefix} finding or creating joke of the day")

    # Check to see if we already selected/saved a joke for today
    JokeHistory.used_on(Date.utc_today())
    |> Repo.one()
    |> case do
      %JokeHistory{} = joke_history ->
        Logger.debug("#{@logger_prefix} found existing joke\n#{inspect(joke_history)}")
        {:ok, Joke.new(joke_history)}

      nil ->
        Logger.debug("#{@logger_prefix} did not find existing joke")
        select_joke_of_the_day()
    end
  end

  def select_joke_of_the_day do
    jokes_api = Application.get_env(:daily_dad_jokes, :jokes_api)

    Logger.debug("#{@logger_prefix} fetching joke of the day with #{jokes_api}")

    case jokes_api.get_random_jokes(%{count: 10}) do
      {:ok, jokes} ->
        jokes
        |> within_general_category()
        |> within_text_limits()
        |> unused_in_past_year()
        |> case do
          [] ->
            # retry another random set of jokes
            Logger.warn("#{@logger_prefix} retrying select_joke_of_the_day")
            select_joke_of_the_day()

          jokes ->
            joke =
              Enum.random(jokes)
              |> Map.take([:id, :punchline, :setup, :type])
              |> Joke.new()

            {:ok, joke}
        end

      {:error, :timeout} ->
        Logger.warn("#{@logger_prefix} timed out in select_joke_of_the_day")
        {:error, :timeout}
    end
  end

  def save_joke_history(%Joke{} = joke) do
    Logger.debug("#{@logger_prefix} saving joke history\n\t#{inspect(joke)}")

    joke
    |> Map.from_struct()
    |> Map.drop([:id])
    |> Map.merge(%{
      # Joke ids from the API can be either integers or UUIDs, so we need to
      # cast them to_string to ensure they are handled properly.
      joke_id: to_string(joke.id),
      sent_on: Date.utc_today(),
      recipient_count: 0
    })
    |> JokeHistory.changeset()
    |> Repo.insert()
  rescue
    # NOTE: If we're here it's because we tried to insert the same
    # joke_id/sent_on value and hit the unique constraint in the database.
    Ecto.ConstraintError ->
      {:ok,
       JokeHistory.used_on(Date.utc_today())
       |> Repo.one()}
  end

  def save_joke_history(%JokeHistory{} = joke_history) do
    Logger.debug("#{@logger_prefix} saving joke history\n\t#{inspect(joke_history)}")

    joke_history
    |> JokeHistory.changeset()
    |> Repo.insert(
      on_conflict: [set: [recipient_count: joke_history.recipient_count]],
      conflict_target: :id
    )
  end

  def find_subscribers_for_delivery_window(now \\ Timex.now()) do
    # Get a distinct list of time zones & time of days from all verified subscribers
    delivery_windows =
      Subscriber.delivery_windows()
      |> Repo.all()

    # Determine if we're in the delivery window for any subscribers
    current_delivery_windows =
      delivery_windows
      |> Enum.reduce([], fn [time_of_day, time_zone] = window, acc ->
        case Timex.Timezone.convert(now, time_zone) do
          %{hour: ^time_of_day} -> [window | acc]
          _ -> acc
        end
      end)

    # Get verified subscribers in the current delivery window(s)
    current_delivery_windows
    |> Enum.reduce([], fn [time_of_day, time_zone], acc ->
      subscribers =
        Subscriber.verified()
        |> Subscriber.in_time_zone(time_zone)
        |> Subscriber.at_time_of_day(time_of_day)
        |> Repo.all()

      [subscribers | acc]
    end)
    |> List.flatten()
  end

  def deliver_joke_to_subscribers(joke, subscribers) when is_list(subscribers) do
    sms_gateway = Application.get_env(:daily_dad_jokes, :sms_gateway)
    body = "#{joke.setup}\n\n#{joke.punchline}"

    subscribers
    |> Task.async_stream(
      &sms_gateway.send_sms(&1.phone_number, body),
      on_timeout: :kill_task
    )
    |> Enum.zip(subscribers)
  end

  defp unused_in_past_year(jokes) do
    last_year = Timex.now() |> Timex.shift(years: -1)

    unused_joke_ids =
      jokes
      |> Enum.map(fn joke -> joke.id end)
      |> JokeHistory.unused_joke_ids_since(last_year)

    Enum.filter(jokes, fn joke ->
      # Joke ids from the API can be either integers or UUIDs, so we need to
      # cast them all to_string to compare them correctly.
      to_string(joke.id) in unused_joke_ids
    end)
  end

  defp within_general_category(jokes) do
    Enum.filter(jokes, fn %{type: type} ->
      String.downcase(type) == "general"
    end)
  end

  defp within_text_limits(jokes, max \\ 160) do
    Enum.filter(jokes, fn %{setup: setup, punchline: punchline} ->
      String.trim(setup) |> String.length() <= max and
        String.trim(punchline) |> String.length() <= max
    end)
  end
end
