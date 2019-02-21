defmodule Battleship.Game do

  def new do
    board1 = new_board()
    board2 = new_board()

    %{
      board1: board1,
      board2: board2,
      players: %{},
    }
  end

  def new(players) do
    players = Enum.map players, fn {name, info} ->
      {name, %{ default_player() | score: info.score || 0 }}
    end
    Map.put(new(), :players, Enum.into(players, %{}))
  end

  def default_player() do
    %{
      score: 0,
      cooldown: nil,
    }
  end

  def get_cd(game, user) do
    done = (get_in(game.players, [user, :cooldown]) || 0)
    left = done - :os.system_time(:milli_seconds)
    max(left, 0)
  end

  # https://stackoverflow.com/questions/51342981/how-to-print-a-grid-from-coordinates-like-0-0-in-a-mapset-in-elixir
  def new_board do
    board = for col <- 1..10, row <- 1..10, into: %{}, do: {{col, row}, %{ship: false, guessed: false,}}

    board
  end

  def client_view(game, user) do
    ps = Enum.map game.players, fn {pn, pi} ->
      %{ name: pn, score: pi.score }
    end
    boards = [%{board: game.board1, player: Enum.at(game.players, 0)},
              %{board: game.board2, player: Enum.at(game.players, 1)}]

    %{
      boards: boards,
      player_board: Enum.at(boards, 0),
      opponent_board: Enum.at(boards, 1),
      score: 0,
      players: ps,      
    }

  end

  def skeleton(board) do 
    board_symbols = for col <- 1..10, row <- 1..10, into: %{}, do:
      {cond do 
        Map.get(board[{col, row}], :guessed) && Map.get(board[{col, row}], :ship) ->
          {{col, row}, %{symbol: "X",}}
        Map.get(board[{col, row}], :guessed) && !Map.get(board[{col, row}], :ship) ->
          {{col, row}, %{symbol: "O",}}
        true ->
          {{col, row}, %{symbol: " ",}}
      end}
    board_symbols
  end

end
