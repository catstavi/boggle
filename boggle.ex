letter_grid = [
  ["p", "c", "s", "t"],
  ["h", "a", "r", "x"],
  ["s", "t", "x", "x"],
  ["x", "s", "y", "t"]
]

board = Board.get_board(letter_grid)
starter = Enum.at(board, 1)
Boggle.gather_words(board, [starter])

defmodule Boggle do
  def gather_words(board, selected_dice) do

    prefix = selected_dice
    |> Enum.reduce("", fn die, word -> word <> die.letter end)

    words = case Dictionary.valid_prefix?(prefix) do
      true ->
        Board.valid_continuations(board, selected_dice)
        |> Enum.flat_map(&gather_words(board, selected_dice ++ [&1]))
        |> MapSet.new
      false ->
        MapSet.new()
    end

    if Dictionary.is_word?(prefix) do MapSet.put(words, prefix) else words end
  end
end

defmodule Board do

  defmodule Die do
    defstruct letter: nil, x: nil, y: nil
  end

  def get_board(letter_grid) do
    letter_grid
    |> Enum.with_index
    |> Enum.flat_map(fn {row, y} ->
      row
      |> Enum.with_index
      |> Enum.map(fn {letter, x} ->
        %Die{letter: letter, x: x, y: y}
      end)
    end)
  end

  def valid_continuations(board, selected_dice) do
    %Die{x: current_x, y: current_y} = List.last(selected_dice)
    Enum.filter(board, fn die->
      abs(current_x - die.x) <= 1 and
      abs(current_y - die.y) <= 1 and
      !Enum.member?(selected_dice, die)
    end)
  end
end

# TODO: ... obviously not an actual dictionary. we'll want a bunch of words loaded into a trie
defmodule Dictionary do
  def valid_prefix?(string) do
    String.length(string) < 5
  end

  def is_word?("cat"), do: true
  def is_word?("chap"), do: true
  def is_word?("cats"), do: true
  def is_word?("car"), do: true
  def is_word?("cart"), do: true
  def is_word?("carts"), do: true
  def is_word?("catty"), do: true
  def is_word?(_), do: false
end
