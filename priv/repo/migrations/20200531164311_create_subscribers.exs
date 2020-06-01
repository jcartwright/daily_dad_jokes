defmodule DailyDadJokes.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :phone_number, :string
      add :time_zone, :string
      add :verified_at, :naive_datetime
      add :unsubscribed_at, :naive_datetime

      timestamps()
    end

    create unique_index(:subscribers, [:phone_number])
    create index(:subscribers, [:time_zone, :verified_at, :unsubscribed_at])
  end
end
