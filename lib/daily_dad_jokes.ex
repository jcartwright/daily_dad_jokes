defmodule DailyDadJokes do
  @moduledoc """
  DailyDadJokes keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  require Logger
  @logger_prefix "[daily-dad-jokes]"

  alias DailyDadJokes.Api
  alias DailyDadJokes.Core.{Joke, JokeHistory}
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
    Logger.debug("#{@logger_prefix} selecting joke of the day")

    case Api.get_random_jokes(%{count: 10}) do
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
      joke_id: joke.id,
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

  defp unused_in_past_year(jokes) do
    last_year = Timex.now() |> Timex.shift(years: -1)

    unused_joke_ids =
      jokes
      |> Enum.map(fn joke -> joke.id end)
      |> JokeHistory.unused_joke_ids_since(last_year)

    Enum.filter(jokes, fn joke ->
      joke.id in unused_joke_ids
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
