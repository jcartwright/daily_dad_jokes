defmodule DailyDadJokesWeb.Schema.CoreTypes do
  @moduledoc """
  Provides GraphQL Type definitions for Core entities.
  """
  use Absinthe.Schema.Notation

  @desc "A joke"
  object :joke do
    field :id, non_null(:id)
    field :setup, :string
    field :punchline, :string
    field :type, :string
  end
end
