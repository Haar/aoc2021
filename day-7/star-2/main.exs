defmodule CrabArmy do
  def calculate_alignment!(positions) do
    mean_ceil = Enum.sum(positions) / length(positions) |> ceil()
    mean_floor = Enum.sum(positions) / length(positions) |> floor()

    [mean_ceil, mean_floor]
    |> Enum.map(fn (midpoint) -> calculate_fuel_cost(midpoint, positions) end)
    |> Enum.min()
  end

  defp calculate_fuel_cost(midpoint, positions) do
    positions
    |> Enum.frequencies()
    |> Enum.map(fn ({position, count}) -> Enum.sum(0..(position-midpoint)) * count end)
    |> Enum.map(&abs/1)
    |> Enum.sum()
  end
end

# Test
# "16,1,2,0,4,2,7,1,2,14"
# |> String.split(",", trim: true)
# |> Enum.map(&String.to_integer/1)
# |> CrabArmy.calculate_alignment!()
# |> IO.inspect(label: "output")

"./input.txt"
|> File.read!()
|> String.trim()
|> String.split(",", trim: true)
|> Enum.map(&String.to_integer/1)
|> CrabArmy.calculate_alignment!()
|> IO.inspect(label: "output")
