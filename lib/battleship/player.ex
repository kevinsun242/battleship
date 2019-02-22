defmodule Battleship.Player do
  alias Battleship.Game

  defstruct [:board, :name, :id, :turns]

  def new(name) do
    %Player{turns: 0, board: Board.new, id: id, name: name}
  end

  def turn(player) do
    %{ player | turns: player.turns + 1 }
  end

  def won?(player) do
    Board.over?(player.board)
  end
end
