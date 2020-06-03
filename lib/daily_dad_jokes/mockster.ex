defmodule DailyDadJokes.Mockster do
  @moduledoc false
  use GenServer

  require Logger
  @logger_prefix "[mockster]"

  ## Startup functions

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    Logger.debug("#{@logger_prefix} initializing")
    # {:ok, %{}, {:continue, :setup_joke_of_the_day}}
    {:ok, %{}}
  end
end
