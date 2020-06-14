defmodule DailyDadJokes.Api.MockSms do
  @moduledoc false
  @behaviour DailyDadJokes.Behaviours.SmsGateway

  @impl true
  def send_sms(recipient, body) do
    # Simulate a random timeout in development
    delay = Enum.random(1..6) * 1000
    Process.sleep(delay)

    # Return :ok | :error response
    case toggle(recipient) do
      0 -> {:ok, response(recipient, body)}
      _ -> {:error, response(recipient, body)}
    end
  end

  defp response(recipient, body) do
    id = Ecto.UUID.generate() |> String.replace("-", "")

    %{
      id: id,
      body: body,
      recipient: recipient,
      date_created: NaiveDateTime.utc_now(),
      status: "sent"
    }
  end

  defp toggle(recipient) do
    recipient
    |> String.slice(2, 10)
    |> Integer.parse()
    |> case do
      {val, _} -> val
      _ -> 0
    end
    |> Integer.mod(3)
  end
end
