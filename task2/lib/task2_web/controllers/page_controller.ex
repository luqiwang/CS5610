defmodule Task2Web.PageController do
  use Task2Web, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: task_path(conn, :index))
    else
      render conn, "index.html"
    end
  end
end
