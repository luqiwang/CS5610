#this code is based on Professor Nat's code :
#https://github.com/NatTuck/hangman2/blob/proc-state/lib/hangman/game_backup.ex
defmodule Memory.GameBackup do
  use Agent

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(name, game) do
    Agent.update __MODULE__, fn state ->
      Map.put(state, name, game)
    end
  end

  def load(name) do
    Agent.get __MODULE__, fn state ->
      Map.get(state, name)
    end
  end
end
