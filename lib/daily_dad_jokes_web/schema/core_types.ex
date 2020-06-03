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

  @desc "A joke history"
  object :joke_history do
    field :id, non_null(:id)
    field :sent_on, :date
    field :recipient_count, :integer
    field :joke_id, :string
    field :punchline, :string
    field :setup, :string
    field :type, :string
  end
end
