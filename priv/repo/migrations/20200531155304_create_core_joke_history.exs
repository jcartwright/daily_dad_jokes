defmodule DailyDadJokes.Repo.Migrations.CreateCoreJokeHistory do
  use Ecto.Migration

  def change do
    create table(:joke_history, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :joke_id, :string
      add :setup, :string
      add :punchline, :string
      add :type, :string
      add :recipient_count, :integer
      add :sent_on, :date
    end

    create unique_index(:joke_history, [:joke_id, :sent_on])
  end
end
