defmodule DailyDadJokes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  # Choose process implementation based on environment config
  @jokester_module Application.get_env(:daily_dad_jokes, :jokester_module)

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      DailyDadJokes.Repo,
      # Start the endpoint when the application starts
      DailyDadJokesWeb.Endpoint,
      # Starts a worker by calling: DailyDadJokes.Worker.start_link(arg)
      # {DailyDadJokes.Worker, arg},
      {@jokester_module, [name: DailyDadJokes.Jokester]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DailyDadJokes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DailyDadJokesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
