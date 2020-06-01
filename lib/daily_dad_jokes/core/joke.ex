defmodule DailyDadJokes.Core.Joke do
  @moduledoc """
  Represents a Joke entity.
  """
  alias DailyDadJokes.Core.JokeHistory

  defstruct ~w(id punchline setup type)a

  def new(%JokeHistory{} = attrs) do
    attrs
    |> Map.from_struct()
    |> Map.put(:id, attrs.joke_id)
    |> Map.take([:id, :punchline, :setup, :type])
    |> new()
  end

  def new(attrs) do
    struct!(__MODULE__, attrs)
  end
end
