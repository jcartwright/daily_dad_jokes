FROM elixir:1.10-alpine AS builder

# Install build dependencies
RUN apk add --update git build-base npm yarn python

# Prepare build directory
RUN mkdir /app
WORKDIR /app

# Install mix + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set the build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# Build assets
COPY assets assets
COPY priv priv
RUN cd assets && npm install && npm run deploy
RUN mix phx.digest

# Build project
COPY lib lib
RUN mix compile

# Build the release
COPY rel rel
RUN mix release

# Copy the startup script
COPY ./run.sh ./

# Prepare release image
FROM alpine AS app
RUN apk add --update bash openssl postgresql-client

RUN mkdir /app
WORKDIR /app

COPY --from=builder /app/_build/prod/rel/daily_dad_jokes ./
COPY --from=builder /app/run.sh ./

RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

# Execute "run.sh" command with /bin/sh -c
CMD ./run.sh
