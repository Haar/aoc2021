defmodule SonarSweep do
  def scan(list, count \\ 0)
  def scan(list, count) when length(list) < 2, do: count
  def scan([f | [ s | t ]], count) do
    scan([s | t], count + (if f < s, do: 1, else: 0))
  end
end

"./input.txt"
 |> File.stream!()
 |> Stream.map(&String.trim/1)
 |> Enum.map(&String.to_integer(&1))
 |> SonarSweep.scan()
 |> IO.puts()

# Test
# [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
#   |> SonarSweep.scan()
#   |> IO.puts()
