defmodule Memory.Game do
  def new do
    init_chars = ["A","B","C","D","E","F","G","H","A","B","C","D","E","F","G","H"]
    %{
      chars: Enum.shuffle(init_chars),
      tileContents: ["","","","","","","","","","","","","","","",""],
      lockTiles: [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,],
      firstClick: -1,
      count: 0,
      pair: 0,
      inShowTime: false
    }
  end


  def click(game, index) do
    %{chars: chars,
      tileContents: tileContents,
      lockTiles: lockTiles,
      firstClick: firstClick,
      count: count,
      pair: pair,
      inShowTime: inShowTime } = game
      old = game
      tileContents = List.replace_at(tileContents, index, Enum.at(chars, index))
      count = count + 1;
      game = game
        |> Map.put(:count, count)
        |> Map.put(:tileContents, tileContents)
    cond do
      Enum.at(lockTiles, index) || inShowTime || firstClick == index -> old
      firstClick == -1  ->
        game = Map.put(game, :firstClick, index)
      true ->
        if Enum.at(chars, index) == Enum.at(chars, firstClick) do
          lockTiles = lockTiles
            |> List.replace_at(index, true)
            |> List.replace_at(firstClick, true)
          game = game
            |> Map.put(:lockTiles, lockTiles)
            |> Map.put(:pair, pair + 1)
        end
        game = game |> Map.put(:inShowTime, true) |> Map.put(:firstClick, index)
    end
  end

  def flip_back(game) do
    game = game
      |> Map.put(:firstClick, -1)
      |> Map.put(:tileContents, ["","","","","","","","","","","","","","","",""])
      |> Map.put(:inShowTime, false)
  end
end
