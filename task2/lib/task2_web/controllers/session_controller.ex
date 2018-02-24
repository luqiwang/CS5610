# this is based on Professor Nat's notes:
# http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/12-microblog/notes.html
defmodule Task2Web.SessionController do
  use Task2Web, :controller

  alias Task2.Accounts
  alias Task.Accounts.User

  def create(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.name}")
      |> redirect(to: task_path(conn, :index))
    else
      conn
      |> put_flash(:error, "User does not exist")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
