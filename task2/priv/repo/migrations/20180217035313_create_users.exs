defmodule Task2.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :manager_id, references(:users)
      
      timestamps()
    end
  end
end
