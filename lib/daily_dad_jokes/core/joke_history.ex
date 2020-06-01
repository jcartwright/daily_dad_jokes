defmodule DailyDadJokes.Core.JokeHistory do
  @moduledoc """
  An entity that provides historical use of a particular Joke.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias DailyDadJokes.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "joke_history" do
    field :joke_id, :integer
    field :punchline, :string
    field :setup, :string
    field :type, :string
    field :recipient_count, :integer
    field :sent_on, :date
  end

  def unused_joke_ids_since(joke_ids, date) do
    joke_ids = List.wrap(joke_ids)

    # Which of the provided joke_ids have not been used since date?
    used_ids =
      from(jh in used_since(date),
        select: jh.joke_id,
        where: jh.joke_id in (^joke_ids)
      )
      |> Repo.all()

    Enum.filter(joke_ids, fn id -> id not in used_ids end)
  end

  def used_on(query \\ __MODULE__, date) do
    from jh in query,
      where: jh.sent_on == ^date,
      limit: 1
  end

  def used_since(query \\ __MODULE__, date) do
    from jh in query,
      where: jh.sent_on >= ^date
  end

  @doc false
  def changeset(joke_history \\ %__MODULE__{}, attrs) do
    joke_history
    |> cast(attrs, [:joke_id, :setup, :punchline, :type, :recipient_count, :sent_on])
    |> validate_required([:joke_id, :sent_on])
  end
end
