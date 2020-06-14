defmodule DailyDadJokes.Behaviours.SmsGateway do
  @moduledoc false
  @callback send_sms(recipient :: String.t(), body :: String.t()) ::
              {:ok, map()} | {:error, String.t()}
end
