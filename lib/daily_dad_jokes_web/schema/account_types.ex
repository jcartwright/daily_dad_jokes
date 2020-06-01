defmodule DailyDadJokesWeb.Schema.AccountTypes do
  @moduledoc """
  Provides GraphQL Type definitions for Account entities.
  """
  use Absinthe.Schema.Notation

  @desc "A user"
  object :user do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :first_name, :string
    field :last_name, :string
    field :inserted_at, :naive_datetime
    field :updated_at, :naive_datetime
  end
end
