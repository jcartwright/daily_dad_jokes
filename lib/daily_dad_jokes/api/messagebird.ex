defmodule DailyDadJokes.Api.Messagebird do
  @moduledoc """
  Wraps the Messagebird SMS Gateway for sending text messages.

  See: https://developers.messagebird.com/api/sms-messaging/
  """
  @behaviour DailyDadJokes.Behaviours.SmsGateway

  @impl true
  def send_sms(recipients, body) do
    host = System.get_env("MESSAGEBIRD_HOST")
    query = "https://#{host}/messages"

    body =
      %{
        originator: "DlyDadJokes",
        recipients: recipients,
        body: body
      }
      |> Jason.encode!()

    HTTPoison.post(query, body, headers())
    |> case do
      {:ok, %{status_code: status_code, body: body}} when status_code in 200..299 ->
        Jason.decode(body)

      {:ok, %{status_code: _, body: body} = _response} ->
        {:error, Jason.decode!(body)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp headers do
    access_key = System.get_env("MESSAGEBIRD_API_KEY")

    [
      authorization: "AccessKey #{access_key}",
      "content-type": "application/json"
    ]
  end

end
