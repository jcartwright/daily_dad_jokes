defmodule DailyDadJokes.Repo.Migrations.AddSubscriberDeliveryTimeOfDay do
  use Ecto.Migration

  def change do
    alter table(:subscribers) do
      add :time_of_day, :integer
    end

    create index(:subscribers, [:time_of_day, :time_zone])

    create index(:subscribers, [
             :time_zone,
             :time_of_day,
             :verified_at,
             :unsubscribed_at
           ])

    drop_if_exists index(:subscribers, [
                     :time_zone,
                     :verified_at,
                     :unsubscribed_at
                   ])
  end
end
