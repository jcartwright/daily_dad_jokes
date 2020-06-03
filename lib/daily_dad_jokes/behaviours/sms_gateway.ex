defmodule DailyDadJokes.Behaviours.SmsGateway do
  @moduledoc false
  @callback send_sms(list(String.t()), String.t()) :: {:ok, map()} | {:error, String.t()}
end
