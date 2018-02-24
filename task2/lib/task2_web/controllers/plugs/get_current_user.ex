defmodule Task2.Plugs.GetCurrentUser do
  import Plug.Conn
  import Phoenix.Controller

  # alias Discuss.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Task2.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end
end
