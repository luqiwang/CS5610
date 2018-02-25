defmodule Task2.Social.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Task2.Social.Timeblock


  schema "timeblocks" do
    field :end_time, :integer
    field :start_time, :integer
    belongs_to :task, Task2.Social.Task

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> validate_required([:start_time, :end_time, :task_id])
  end
end
