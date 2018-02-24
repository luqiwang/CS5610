defmodule Task2.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :body, :text, null: false
      add :time, :integer
      add :creater_id, references(:users, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
    create index(:tasks, [:creater_id])
  end
end
