defmodule LanternFish do
  def model(state, iterations) do
    Enum.reduce(1..iterations, state, fn(_turn, state) -> tick(state) end)
  end

  defp tick(state) do
    state
    |> Enum.map(&age/1)
    |> List.flatten()
  end

  defp age(fish) do
    case fish do
      0 -> [6, 8]
      _ -> fish - 1
    end
  end
end

# Test
# "3,4,3,1,2"
# |> String.split(",", trim: true)
# |> Enum.map(&String.to_integer/1)
# |> LanternFish.model(80)
# |> length()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split(",", trim: true)
|> Enum.map(&String.to_integer/1)
|> LanternFish.model(80)
|> length()
|> IO.inspect()
