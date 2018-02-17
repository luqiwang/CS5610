defmodule Task1Web.Router do
  use Task1Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Task1.Plugs.GetCurrentUser
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Task1Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/tasks", TaskController do
      get "/complete", TaskController, :complete, as: :complete
    end
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Task1Web do
  #   pipe_through :api
  # end
end
