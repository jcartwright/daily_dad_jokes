defmodule DailyDadJokes.Core.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "subscribers" do
    field :phone_number, :string
    field :time_of_day, :integer
    field :time_zone, :string
    field :unsubscribed_at, :naive_datetime
    field :verified_at, :naive_datetime

    timestamps()
  end

  @doc """
  Returns a distinct query of time_zones and time_of_days.
  """
  def delivery_windows(query \\ __MODULE__) do
    from s in query,
      distinct: true,
      select: [s.time_of_day, s.time_zone]
  end

  @doc """
  Returns a query of verified, and NOT unsubscribed subscribers.
  """
  def verified(query \\ __MODULE__) do
    from s in query,
      where: not is_nil(s.verified_at),
      where: is_nil(s.unsubscribed_at)
  end

  @doc """
  Returns a query of subscribers with the specified time_of_day.
  """
  def at_time_of_day(query \\ __MODULE__, time_of_day) do
    from s in query,
      where: s.time_of_day == ^time_of_day
  end

  @doc """
  Returns a query of subscribers with the specified time_zone.
  """
  def in_time_zone(query \\ __MODULE__, time_zone) do
    from s in query,
      where: s.time_zone == ^time_zone
  end

  @doc false
  def changeset(subscriber \\ %__MODULE__{}, attrs) do
    subscriber
    |> cast(attrs, [
      :phone_number,
      :time_of_day,
      :time_zone,
      :verified_at,
      :unsubscribed_at
    ])
    |> validate_required([:phone_number, :time_of_day, :time_zone])
  end
end
