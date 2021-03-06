defmodule Task2Web.UserController do
  use Task2Web, :controller

  alias Task2.Accounts
  alias Task2.Accounts.User
  alias Task2.Social

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    user_id_list = Accounts.get_all_id()
    user_id_list = [0 | user_id_list]
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset, user_id_list: user_id_list)
  end

  def create(conn, %{"user" => user_params}) do
    if Map.get(user_params, "manager_id") == "0" do
        user_params = Map.delete(user_params, "manager_id")
    end
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    tasks = Social.get_tasks_posted(id)
    render(conn, "show.html", user: user, tasks: tasks)
  end

  def edit(conn, %{"id" => id}) do
    user_id_list = Accounts.get_all_id()
    user_id_list = [0 | user_id_list]
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, user_id_list: user_id_list)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
