defmodule Task2Web.TaskController do
  use Task2Web, :controller

  alias Task2.Social
  alias Task2.Social.Task
  alias Task2.Accounts

  def index(conn, _params) do
    tasks = Social.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, params) do
    user_id_list = Accounts.get_all_id(conn.assigns.current_user.id)
    if (length(user_id_list)) == 0 do
      conn
      |> put_flash(:error, "You are not a manager.")
      |> redirect(to: task_path(conn, :index))
    else
      changeset = Social.change_task(%Task{})
      render(conn, "new.html", changeset: changeset, task: %Task{}, user_id_list: user_id_list)
    end

  end


  def create(conn, %{"task" => task_params}) do
    case Social.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, task: %Task{})
    end
  end

  def show(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    user_id_list = Accounts.get_all_id(conn.assigns.current_user.id)
    task = Social.get_task!(id)
    changeset = Social.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset, user_id_list: user_id_list)
  end


  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)
    case Social.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    {:ok, _task} = Social.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  def complete(conn, %{"task_id" => id}) do
    task = Social.get_task!(id)
    time = List.foldr(task.timeblocks, 0, fn(x, acc) -> diff_time(x) + acc end)
    changeset = Social.change_task(task)
    render(conn, "complete.html", task: task, changeset: changeset, time: time)
  end

  def diff_time(timeblock) do
    start_time =  Integer.floor_div(timeblock.start_time, 1000)
    end_time =  Integer.floor_div(timeblock.end_time, 1000)
    Integer.floor_div((end_time - start_time), 60)
  end

end
