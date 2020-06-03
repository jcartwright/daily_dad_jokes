defmodule DailyDadJokes.Api.MockJokes do
  @moduledoc false
  @behaviour DailyDadJokes.Behaviours.JokesApi

  alias DailyDadJokes.Core.Joke

  @impl true
  def get_random_jokes(_args) do
    {:ok,
     [
       %Joke{
         id: Ecto.UUID.generate(),
         setup: "Why did the chicken cross the road?",
         punchline: "To get to the other side",
         type: "general"
       }
     ]}
  end
end
