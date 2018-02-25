defmodule Task2.Social.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Task2.Social.Task


  schema "tasks" do
    field :body, :string
    field :time, :integer
    field :title, :string
    belongs_to :creater, Task2.Accounts.User
    belongs_to :user, Task2.Accounts.User
    has_many :timeblocks ,Task2.Social.Timeblock, foreign_key: :task_id 

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :body, :user_id, :creater_id, :time])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:creater_id)
    |> validate_required([:title, :body, :creater_id, :user_id])
  end
end
