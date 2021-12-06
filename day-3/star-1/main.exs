defmodule Diagnostics do
  def calculate_rates(report) do
    position_occurances =
      report
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Stream.zip()
      |> Stream.map(&Tuple.to_list/1)
      |> Stream.map(&Enum.frequencies/1)
      |> Stream.map(&Map.to_list/1)

    gamma_rate = calculate_rate(position_occurances, &Enum.max_by/2)

    epsilon_rate = calculate_rate(position_occurances, &Enum.min_by/2)

    {gamma_rate, epsilon_rate}
  end

  defp calculate_rate(position_occurances, calculation) do
    position_occurances
    |> Stream.map(fn x -> calculation.(x, &elem(&1, 1)) end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.join("")
    |> String.to_integer(2)
  end
end

"./input.txt"
|> File.stream!()
|> Diagnostics.calculate_rates()
|> Tuple.product()
|> IO.puts()

# Test
# """
# 00100
# 11110
# 10110
# 10111
# 10101
# 01111
# 00111
# 11100
# 10000
# 11001
# 00010
# 01010
# """
# |> String.split("\n", trim: true)
# |> Diagnostics.calculate_rates()
# |> Tuple.product()
# |> IO.puts()
