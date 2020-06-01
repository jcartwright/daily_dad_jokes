defmodule DailyDadJokes.Core.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "subscribers" do
    field :phone_number, :string
    field :time_zone, :string
    field :unsubscribed_at, :naive_datetime
    field :verified_at, :naive_datetime

    timestamps()
  end

  def verified(query \\ __MODULE__) do
    from s in query,
      where: not is_nil(s.verified_at),
      where: is_nil(s.unsubscribed_at)
  end

  def in_time_zone(query \\ __MODULE__, time_zone) do
    from s in query,
      where: s.time_zone == ^time_zone
  end

  @doc false
  def changeset(subscriber \\ %__MODULE__{}, attrs) do
    subscriber
    |> cast(attrs, [:phone_number, :time_zone, :verified_at, :unsubscribed_at])
    |> validate_required([:phone_number, :time_zone])
  end
end
