defmodule DailyDadJokes.Api.DadJokes do
  @moduledoc """
  Wraps access to the Rapid API > Dad Jokes API.

  See: https://rapidapi.com/KegenGuyll/api/dad-jokes/endpoints
  """
  @behaviour DailyDadJokes.Behaviours.JokesApi

  require Logger
  @logger_prefix "[dad-jokes-api]"
  @timeout 10_000

  @impl true
  def get_random_jokes(params) do
    host = System.get_env("RAPID_API_DAD_JOKES_HOST")
    count = Map.take(params, [:count]) |> get_valid_count()
    query = "https://#{host}/random/jokes/#{count}"

    Logger.info("#{@logger_prefix} #{query}")

    HTTPoison.get(query, headers(), recv_timeout: @timeout)
    |> case do
      {:ok, %{status_code: 200, body: body} = response} ->
        log_rate_limit_info(response)
        Jason.decode(body, keys: :atoms)

      {:ok, %{status_code: _, body: body} = response} ->
        log_rate_limit_info(response)
        {:error, Jason.decode!(body)["message"]}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp get_valid_count(%{count: count}) when is_integer(count) do
    cond do
      count > 50 ->
        Logger.warn("#{@logger_prefix} max count is 50, received #{count}")
        50

      count > 1 ->
        count

      true ->
        nil
    end
  end

  defp get_valid_count(_), do: nil

  defp headers do
    [
      "x-rapidapi-host": System.get_env("RAPID_API_DAD_JOKES_HOST"),
      "x-rapidapi-key": System.get_env("RAPID_API_KEY")
    ]
  end

  defp log_rate_limit_info(%{headers: headers}) do
    limit =
      Enum.find(headers, fn {k, _} -> k == "X-RateLimit-Requests-Limit" end)
      |> case do
        {_, value} -> value
        _ -> "undefined"
      end

    remaining =
      Enum.find(headers, fn {k, _} -> k == "X-RateLimit-Requests-Remaining" end)
      |> case do
        {_, value} -> value
        _ -> "undefined"
      end

    Logger.info("#{@logger_prefix} #{remaining} of #{limit} requests remaining")
  end
end
