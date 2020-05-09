defmodule DailyDadJokesWeb.PageController do
  use DailyDadJokesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
