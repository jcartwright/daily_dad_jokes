defmodule DailyDadJokes.Api.Twilio do
  @moduledoc """
  Wraps the Twilio SMS Gateway for sending text messages.

  See: https://www.twilio.com/docs/sms/api/message-resource
  """
  @behaviour DailyDadJokes.Behaviours.SmsGateway

  require Logger

  @impl true
  def send_sms(recipient, body) do
    ExTwilio.Message.create(
      to: recipient,
      from: twilio_number(),
      body: body
      # status_callback: "#{status_callback_url()}/#{tag}"
    )
    |> case do
      {:ok, result} ->
        Logger.debug("Twilio Response: #{inspect(result)}")
        {:ok, result}

      {:error, result, _http_status_code} ->
        Logger.debug("Twilio Response: #{inspect(result)}")
        {:error, result}
    end
  end

  defp twilio_number do
    System.get_env("TWILIO_DEFAULT_NUMBER", "+12056560939")
  end
end
