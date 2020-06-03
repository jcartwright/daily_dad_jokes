defmodule DailyDadJokesWeb.Schema do
  @moduledoc """
  Provides the GraphQL Schema.
  """
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import_types(DailyDadJokesWeb.Schema.AccountTypes)
  import_types(DailyDadJokesWeb.Schema.CoreTypes)

  alias DailyDadJokesWeb.Resolvers

  query do
    @desc "Get a joke by its id"
    field :joke_of_the_day, :joke do
      resolve(&Resolvers.Core.get_joke_of_the_day/3)
    end

    @desc "Get the joke history for the last N days"
    field :joke_history, list_of(:joke_history) do
      resolve(&Resolvers.Core.get_joke_history/3)
    end
  end
end
