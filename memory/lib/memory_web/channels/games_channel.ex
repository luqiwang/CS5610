defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Game.new()
      socket = socket
        |> assign(:game, game)
        |> assign(:name, name)
      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"index" => index}, socket) do
    game = Game.click(socket.assigns[:game], index)
    IO.puts(game.inShowTime)
    socket = assign(socket, :game, game)
     {:reply, {:ok, %{ "game" => game}}, socket}
  end

  def handle_in("flip_back", %{"game" => game}, socket) do
    game = Game.flip_back(socket.assigns[:game])
    socket = assign(socket, :game, game)
     {:reply, {:ok, %{ "game" => game}}, socket}
  end

  def handle_in("restart", _params, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
     {:reply, {:ok, %{ "game" => game}}, socket}
  end

  defp authorized?(_payload) do
    true
  end
end
