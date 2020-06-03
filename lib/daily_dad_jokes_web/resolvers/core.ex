defmodule DailyDadJokesWeb.Resolvers.Core do
  @moduledoc """
  Provides a resolver for GraphQL Core queries.
  """
  alias DailyDadJokes.Core.{Joke, JokeHistory}
  alias DailyDadJokes.Repo

  def get_joke_of_the_day(_parent, _args, _info) do
    Date.utc_today()
    |> JokeHistory.used_on()
    |> Repo.one()
    |> case do
      nil ->
        {:error, "Could not find the joke of the day"}

      joke_history ->
        {:ok,
         %Joke{
           id: joke_history.joke_id,
           punchline: joke_history.punchline,
           setup: joke_history.setup,
           type: joke_history.type
         }}
    end
  end

  def get_joke_history(_parent, _args, _info) do
    # Return joke history for the past 30 days
    history =
      Date.utc_today()
      |> Timex.shift(days: -30)
      |> JokeHistory.used_since()
      |> Repo.all()

    {:ok, history}
  end
end
