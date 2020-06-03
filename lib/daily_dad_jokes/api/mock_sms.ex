defmodule DailyDadJokes.Api.MockSms do
  @moduledoc false
  @behaviour DailyDadJokes.Behaviours.SmsGateway

  @impl true
  def send_sms(recipients, body) do
    {:ok, response()}
  end

  defp response do
    %{
      id: "e8077d803532c0b5937c639b60216938",
      href: "https://rest.messagebird.com/messages/e8077d803532c0b5937c639b60216938",
      direction: "mt",
      type: "sms",
      originator: "YourName",
      body: "This is a test message",
      reference: nil,
      validity: nil,
      gateway: nil,
      typeDetails: %{},
      datacoding: "plain",
      mclass: 1,
      scheduledDatetime: nil,
      createdDatetime: "2016-05-03T14:26:57+00:00",
      recipients: %{
        totalCount: 1,
        totalSentCount: 1,
        totalDeliveredCount: 0,
        totalDeliveryFailedCount: 0,
        items: [
          %{
            recipient: 31_612_345_678,
            status: "sent",
            statusDatetime: "2016-05-03T14:26:57+00:00"
          }
        ]
      }
    }
  end
end
