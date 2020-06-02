#!/bin/sh

set -e

# wait for postgres to become available
while ! pg_isready -h $POSTGRES_HOST
do
  echo "Waiting for postgres to accept connections"
  sleep 2
done

# run any pending migrations
bin/daily_dad_jokes eval "DailyDadJokes.ReleaseTasks.migrate"

# start up the app & web server
bin/daily_dad_jokes start
