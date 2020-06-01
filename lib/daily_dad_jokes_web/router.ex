defmodule DailyDadJokesWeb.Router do
  use DailyDadJokesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :graphql do
  #   plug Plugs.Graphql.Context
  # end

  scope "/graphql" do
    # pipe_through :graphql

    forward "/",
            Absinthe.Plug,
            schema: DailyDadJokesWeb.Schema
  end

  scope "/graphiql" do
    # pipe_through :graphql

    forward "/",
            Absinthe.Plug.GraphiQL,
            schema: DailyDadJokesWeb.Schema,
            interface: :simple
  end

  scope "/", DailyDadJokesWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
