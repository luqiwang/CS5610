defmodule Task1Web.TaskController do
  use Task1Web, :controller

  alias Task1.Social
  alias Task1.Social.Task

  def index(conn, _params) do
    tasks = Social.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Social.change_task(%Task{})
    render(conn, "new.html", changeset: changeset, task: %Task{})
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
    task = Social.get_task!(id)
    changeset = Social.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end


  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)
    %{"time" => time} = task_params
    time = String.to_integer(time)
    time = Integer.floor_div(time, 15) * 15
    time = Integer.to_string(time)
    task_params = Map.replace!(task_params, "time", time)

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
    changeset = Social.change_task(task)
    render(conn, "complete.html", task: task, changeset: changeset)
  end

end
