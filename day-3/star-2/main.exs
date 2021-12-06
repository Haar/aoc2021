defmodule Diagnostics do
  def generate_lifesupport_ratings(report) do
    o2_rating  = calculate_rate(report, "1", &>/2)
    co2_rating = calculate_rate(report, "0", &</2)

    {o2_rating, co2_rating}
  end

  defp calculate_rate(_, _, _, index \\ 0)
  defp calculate_rate(to_filter, _, _, _) when length(to_filter) == 1 do
    to_filter
    |> Enum.join("")
    |> String.to_integer(2)
  end
  defp calculate_rate(to_filter, preferred, comparison, index) do
    %{"0" => zeroes, "1" => ones} = count_frequencies_at(to_filter, index)

    remaining =
      cond do
        zeroes == ones            -> Enum.filter(to_filter, &(String.at(&1, index) == preferred))
        comparison.(zeroes, ones) -> Enum.filter(to_filter, &(String.at(&1, index) == "0"))
        true                      -> Enum.filter(to_filter, &(String.at(&1, index) == "1"))
      end

    calculate_rate(remaining, preferred, comparison, index + 1)
  end

  defp count_frequencies_at(diagnostics, char_position) do
    diagnostics
    |> Enum.map(&String.at(&1, char_position))
    |> Enum.frequencies()
  end
end

"./input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Diagnostics.generate_lifesupport_ratings()
|> Tuple.product()
|> IO.inspect()

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
# |> Diagnostics.generate_lifesupport_ratings()
# |> Tuple.product()
# |> IO.inspect()
