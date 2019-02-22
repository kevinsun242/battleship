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
    board = for row <- 1..10, col <- 1..10, into: [], do: %{column: col, row: row, ship: false, guessed: false,}

    add_ships(board)
  end

  def add_ships(board) do
    usedrows = []
    column = Enum.random(1..6)
    row = Enum.random(1..10)

    newboard = Enum.map(board, fn (x) -> 
      if Map.get(x, :row) == row && (Map.get(x, :column) == column ||
                                    Map.get(x, :column) == (column + 1) ||
                                    Map.get(x, :column) == (column + 2) ||
                                    Map.get(x, :column) == (column + 3) ||
                                    Map.get(x, :column) == (column + 4)) do
        %{column: Map.get(x, :column), row: Map.get(x, :row), ship: true, guessed: false,}
      else
        x
      end
    end
    )
    newboard
  end

  def client_view(game, user) do
    ps = Enum.map game.players, fn {pn, pi} ->
      %{ name: pn, score: pi.score }
    end
    boards = [%{board: game.board1, player: Enum.at(game.players, 0)},
              %{board: game.board2, player: Enum.at(game.players, 1)}]

    %{
      boards: boards,
      player_board: skeleton_own(Map.get(Enum.at(boards, 0), :board)),
      opponent_board: skeleton_opponent(Map.get(Enum.at(boards, 1), :board)),
      score: 0,
      players: ps,      
    }

  end

  def skeleton_own(board) do 
    Enum.map board, fn square ->
      cond do 
        Map.get(square, :guessed) && Map.get(square, :ship) ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: "X",}
        Map.get(square, :guessed) && !Map.get(square, :ship) ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: "O",}
        !Map.get(square, :guessed) && Map.get(square, :ship) ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: "S",}
        true ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: " ",}
      end
    end
  end

  def skeleton_opponent(board) do 
    Enum.map board, fn square ->
      cond do 
        Map.get(square, :guessed) && Map.get(square, :ship) ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: "X",}
        Map.get(square, :guessed) && !Map.get(square, :ship) ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: "O",}
        true ->
          %{column: Map.get(square, :column), row: Map.get(square, :row), symbol: " ",}
      end
    end
  end

  def guess(game, player, row, column) do
    board1 = game.board1
    board2 = game.board2
    score = game.score

    newboard = Enum.map(board1, fn (x) ->
      if Map.get(x, :row) == row && Map.get(x, :column) == column do
        Map.put(x, :guessed, true)
      else
        x
      end
    end)

    newboards = [%{board: newboard, player: Enum.at(game.players, 0)},
      %{board: board2, player: Enum.at(game.players, 1)}]

    pinfo = Map.get(game, player, default_player())
    |> Map.put(:cooldown, :os.system_time(:milli_seconds) + 10_000)

    game
    |> Map.put(game, :boards, newboards)
    |> Map.put(game, :player_board, skeleton_own(newboard))
    |> Map.put(game, :opponent_board, skeleton_own(board2))
    |> Map.put(game, :score, score)
    |> Map.update(:players, %{}, &(Map.put(&1, player, pinfo)))
  end

end
