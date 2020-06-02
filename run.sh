#!/bin/sh

set -e

# wait for postgres to become available
until psql -h db -U $POSTGRES_USER -c '\q' 2>/dev/null; do
  >&2 echo "Waiting for postrges to start"
  sleep 10
done

# run any pending migrations
bin/daily_dad_jokes eval "DailyDadJokes.ReleaseTasks.migrate"

# start up the app & web server
bin/daily_dad_jokes start
