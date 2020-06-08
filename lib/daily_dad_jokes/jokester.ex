defmodule DailyDadJokes.Jokester do
  @moduledoc """
  Process that sends scheduled jokes to subscribers.

  At midnight UTC:
  - query candidates for the daily dad joke
  - filter to select and queue the best candidate (type, text-length, etc)
  - record selection in joke history table
  - schedule first callback for daily delivery

  At each hourly callback:
  - select verified subscribers in the current time zone
  - call the SMS gateway to deliver jokes to each subscriber
  - increment recipient count on joke history record
  - schedule next callback for delivery
  """
  use GenServer

  require Logger
  @logger_prefix "[jokester]"

  ## Startup functions

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    Logger.debug("#{@logger_prefix} initializing")
    {:ok, %{}, {:continue, :setup_joke_of_the_day}}
  end

  ## Server Implementation

  def handle_continue(:setup_joke_of_the_day, state) do
    Logger.debug("#{@logger_prefix} handle_continue :setup_joke_of_the_day")
    do_daily_setup(state)
  end

  def handle_continue(:schedule_next_run, state) do
    Logger.debug("#{@logger_prefix} handle_continue :schedule_next_run")

    next_run_delay = calculate_next_delivery_delay(Timex.now())
    Process.send_after(self(), :deliver_for_time_zone, next_run_delay)
    {:noreply, state}
  end

  def handle_info(:deliver_for_time_zone, state) do
    Logger.debug("#{@logger_prefix} handle_info :deliver_for_time_zone")

    # TODO: select verified subscribers and send them the joke via SMS
    # and update the recipient_count...

    # Schedule the next run/delivery
    {:noreply, state, {:continue, :schedule_next_run}}
  end

  def handle_info(:setup_joke_of_the_day, state) do
    Logger.debug("#{@logger_prefix} handle_info :setup_joke_of_the_day")
    do_daily_setup(state)
  end

  ## Private Helpers

  defp calculate_next_delivery_delay(now) do
    # Deliver once an hour at 5 minutes past the hour
    now
    |> Timex.shift(hours: 1)
    |> Timex.set(minute: 5, second: 0)
    |> Timex.diff(now, :milliseconds)
  end

  defp calculate_next_setup_delay(now) do
    # Schedule a new joke of the day at midnight UTC
    now
    |> Timex.shift(days: 1)
    |> Timex.set(hour: 0, minute: 0, second: 0)
    |> Timex.diff(now, :milliseconds)
  end

  defp do_daily_setup(state) do
    with {:ok, joke} <- DailyDadJokes.find_or_create_joke_of_the_day(),
         {:ok, joke_history} <- DailyDadJokes.save_joke_history(joke) do
      # Schedule the next daily setup
      next_setup_delay = calculate_next_setup_delay(Timex.now())
      Process.send_after(self(), :setup_joke_of_the_day, next_setup_delay)

      # Update the process state to be the newly created joke_history and
      # setup the next delivery scheduler.
      {:noreply, joke_history, {:continue, :schedule_next_run}}
    else
      {:error, :timeout} ->
        Logger.warn("#{@logger_prefix} retrying daily setup")
        # Retry attempt (might be a better way?)
        Process.send_after(self(), :setup_joke_of_the_day, 1000)
        {:noreply, state}

      error ->
        Logger.error("#{@logger_prefix} unable to setup the joke of the day\n#{inspect(error)}")
        {:noreply, state}
    end
  end
end
