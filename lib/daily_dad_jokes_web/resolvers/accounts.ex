defmodule DailyDadJokesWeb.Resolvers.Accounts do
  @moduledoc """
  Provides a resolver for GraphQL Account queries.
  """
  def find_user(_parent, args, _info) do
    user_id = Map.get(args, :id)

    {:ok,
     %{
       id: user_id,
       username: "+19402179962",
       first_name: "Jason",
       last_name: "Cartwright",
       inserted_at: DateTime.utc_now(),
       updated_at: DateTime.utc_now()
     }}
  end
end
