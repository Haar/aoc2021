defmodule Math do
 def mean(list) when is_list(list), do: do_mean(list, 0, 0)

  defp do_mean([], 0, 0), do: nil
  defp do_mean([], t, l), do: t / l
  defp do_mean([x | xs], t, l) do
    do_mean(xs, t + x, l + 1)
  end

  def median([]), do: nil
  def median(list) when is_list(list) do
    midpoint =
      (length(list) / 2)
      |> Float.floor()
      |> round

    {l1, l2} =
      Enum.sort(list)
      |> Enum.split(midpoint)

    case length(l2) > length(l1) do
      true ->
        [med | _] = l2
        med

      false ->
        [m1 | _] = l2
        [m2 | _] = Enum.reverse(l1)
        mean([m1, m2])
    end
  end
end

defmodule CrabArmy do
  def calculate_alignment!(positions) do
    median =
      positions
      |> Math.median()
      |> round()

    positions
    |> Enum.frequencies()
    |> Enum.map(fn ({position, count}) -> (position - median) * count end)
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
