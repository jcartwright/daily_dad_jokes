defmodule DailyDadJokesWeb.Resolvers.Core do
  @moduledoc """
  Provides a resolver for GraphQL Core queries.
  """
  alias DailyDadJokes.Api

  def get_random_jokes(_parent, args, _info) do
    # TODO: Implement caching to avoid API rate limits
    Api.get_random_jokes(args)
  end
end
