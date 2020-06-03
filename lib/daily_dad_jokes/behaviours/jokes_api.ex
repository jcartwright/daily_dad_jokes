defmodule DailyDadJokes.Behaviours.JokesApi do
  @moduledoc false
  @callback get_random_jokes(map()) :: {:ok, list(map())} | {:error, String.t()}
end
