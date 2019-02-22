defmodule BattleshipWeb.GamesChannel do
  use BattleshipWeb, :channel

  alias Battleship.GameServer
  alias Battleship.Game
  alias Battleship.BackupAgent

  intercept ["update"]

  def join("games:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      view = GameServer.view(game, socket.assigns[:user])
      {:ok, %{"join" => game, "game" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("guess", %{"row" => row, "column" => column}, socket) do
    view = GameServer.guess(socket.assigns[:game], socket.assigns[:user], row, column)
    push_update! view, socket
    {:reply, {:ok, %{ "game" => view}}, socket}
  end

  def handle_out("update", game_data, socket) do
    IO.inspect("Broadcasting update to #{socket.assigns[:user]}")
    push socket, "update", %{ "game" => game_data }
    {:noreply, socket}
  end

  defp push_update!(view, socket) do
    broadcast!(socket, "update", view)
  end
 
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
