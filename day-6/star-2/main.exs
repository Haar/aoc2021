defmodule LanternFish do
  def model(state, iterations) do
    base_state = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    initial_state =
      state
      |> Enum.frequencies()
      |> Enum.reduce(base_state, fn ({age, count}, state) ->
        List.update_at(state, age, &(&1 + count))
      end)
      |> Enum.reverse()

    Enum.reduce(1..iterations, initial_state, fn(_turn, state) -> tick(state) end)
  end

  defp tick(ages) do
    {zero_count, non_zero_ages} = List.pop_at(ages, -1)

    [zero_count] ++ List.update_at(non_zero_ages, 1, &(&1 + zero_count))
  end
end

# Test
# "3,4,3,1,2"
# |> String.split(",", trim: true)
# |> Enum.map(&String.to_integer/1)
# |> LanternFish.model(256)
# |> Enum.sum()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split(",", trim: true)
|> Enum.map(&String.to_integer/1)
|> LanternFish.model(256)
|> Enum.sum()
|> IO.inspect()
