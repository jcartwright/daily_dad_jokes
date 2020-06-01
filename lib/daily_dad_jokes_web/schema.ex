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
    @desc "Get a list of dad jokes (up to 50)"
    field :random_jokes, list_of(:joke) do
      arg :count, :integer
      resolve(&Resolvers.Core.get_random_jokes/3)
    end

    @desc "Get a registered user"
    field :user, :user do
      arg :id, non_null(:id)
      resolve(&Resolvers.Accounts.find_user/3)
    end
  end
end
