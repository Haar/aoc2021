defmodule Bingo do
  def parse!(input) do
    {[announce_input], cards_input} =
      input
      |> String.split("\n", trim: true)
      |> Enum.split(1)

    cards =
      cards_input
      |> Enum.chunk_every(5)
      |> Enum.map(fn (list) -> Enum.map(list, &String.split(&1, "\s", trim: true)) end)
      |> Enum.map(&Bingo.Card.new/1)

    numbers_to_call = String.split(announce_input, ",", trim: true)

    {numbers_to_call, cards}
  end

  def find_last_winner!({numbers_to_call, cards}) do
    with to_call_with_index <- Enum.with_index(numbers_to_call),
         {:ok, result}      <- evaluate_turns(to_call_with_index, cards)
    do
      result
    else
      _ -> raise "No winner possible"
    end
  end

  defp evaluate_turns(numbers_to_call, cards) do
    Enum.reduce(numbers_to_call, {{nil, []}, cards}, fn ({_, index}, {{last_winner, last_numbers_called}, cards}) ->
      # Skip first few evaluations as a line requires at least 5 numbers called
      if index < 5 do
        {{nil, []}, cards}
      else
        numbers_called_now =
          numbers_to_call
          |> Enum.slice(0..index)
          |> Enum.map(&elem(&1, 0))

        case evaluate_board(cards, numbers_called_now) do
          {:incomplete, _}         -> {{last_winner, last_numbers_called}, cards}
          {:complete, {winners, _}} -> {{winners |> List.last(), numbers_called_now}, cards -- winners}
        end
      end
    end)
    |> (&{:ok, elem(&1, 0)}).()
  end

  defp evaluate_board(cards, numbers_called) do
    winning_cards =
      Enum.filter(cards, &Bingo.Card.is_winning_card?(&1, numbers_called))

    case winning_cards do
      []      -> {:incomplete, {[], numbers_called}}
      winners -> {:complete,   {winners, numbers_called}}
    end
  end

  defmodule Card do
    defstruct [:winnables, :numbers] # [:rows, :columns] # would be more "real" but not required

    def new(numbers) do
      columns =
        numbers
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)

      %Card{
        winnables: numbers ++ columns |> Enum.map(&MapSet.new/1), # rows: rows, columns: columns
        numbers: numbers |> List.flatten() |> Enum.dedup() |> MapSet.new(),
      }
    end

    def is_winning_card?(%Card{winnables: winnables}, called) do
      Enum.any?(winnables, &MapSet.subset?(&1, MapSet.new(called)))
    end

    def remaining_numbers(%Card{numbers: card_numbers}, numbers_called) do
      card_numbers
      |> MapSet.difference(MapSet.new(numbers_called))
      |> MapSet.to_list()
      |> Enum.map(&String.to_integer/1)
    end
  end
end

# Test
# """
# 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
#
# 22 13 17 11  0
#  8  2 23  4 24
# 21  9 14 16  7
#  6 10  3 18  5
#  1 12 20 15 19
#
#  3 15  0  2 22
#  9 18 13 17  5
# 19  8  7 25 23
# 20 11 10 24  4
# 14 21 16 12  6
#
# 14 21 17 24  4
# 10 16 15  9 19
# 18  8 23 26 20
# 22 11 13  6  5
#  2  0 12  3  7
# """
# |> Bingo.parse!()
# |> Bingo.find_last_winner!()
# |> Tuple.to_list()
# |> (&{
#     apply(Bingo.Card, :remaining_numbers, &1) |> Enum.sum(),
#     &1 |> Enum.at(1) |> List.last() |> String.to_integer()
#   }).() # Don't look at me - hacky Value extractions :'D
# |> Tuple.product()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> Bingo.parse!()
|> Bingo.find_last_winner!()
|> IO.inspect()
|> Tuple.to_list()
|> (&{
    apply(Bingo.Card, :remaining_numbers, &1) |> Enum.sum(),
    &1 |> Enum.at(1) |> List.last() |> String.to_integer()
  }).() # Don't look at me - hacky Value extractions :'D
|> Tuple.product()
|> IO.inspect()
