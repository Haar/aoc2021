defmodule SevenSegment do
  def decode(input) do
    [hints, output] = String.split(input, "|", trim: true)

    hints =
      hints
      |> String.split(" ", trim: true)
      |> Enum.map(fn string -> string |> String.split("", trim: true) |> MapSet.new() end)

    one   = Enum.find(hints, fn (map) -> Enum.count(map) == 2 end)
    seven = Enum.find(hints, fn (map) -> Enum.count(map) == 3 end)
    four  = Enum.find(hints, fn (map) -> Enum.count(map) == 4 end)
    eight = Enum.find(hints, fn (map) -> Enum.count(map) == 7 end)
    nine  = Enum.find(hints, fn (map) -> !MapSet.equal?(map, eight) && MapSet.subset?(MapSet.union(seven, four), map) end)
    six   = Enum.find(hints, fn (map) -> Enum.count(map) == 6 && !MapSet.equal?(map, nine) && !MapSet.subset?(one, map) end)
    zero  = Enum.find(hints, fn (map) -> Enum.count(map) == 6 && !MapSet.equal?(map, nine) && MapSet.subset?(one, map) end)
    two   = Enum.find(hints, fn (map) -> Enum.count(map) == 5 && MapSet.subset?(MapSet.difference(eight, nine), map) end)
    five  = Enum.find(hints, fn (map) -> Enum.count(map) == 5 && !MapSet.subset?(MapSet.difference(eight, six), map) end)
    three = Enum.find(hints, fn (map) -> !Enum.member?([zero, one, two, four, five, six, seven, eight, nine], map) end)

    mapping = %{
      zero  |> MapSet.to_list() |> Enum.join("") => "0",
      one   |> MapSet.to_list() |> Enum.join("") => "1",
      two   |> MapSet.to_list() |> Enum.join("") => "2",
      three |> MapSet.to_list() |> Enum.join("") => "3",
      four  |> MapSet.to_list() |> Enum.join("") => "4",
      five  |> MapSet.to_list() |> Enum.join("") => "5",
      six   |> MapSet.to_list() |> Enum.join("") => "6",
      seven |> MapSet.to_list() |> Enum.join("") => "7",
      eight |> MapSet.to_list() |> Enum.join("") => "8",
      nine  |> MapSet.to_list() |> Enum.join("") => "9"
    }

    output
    |> String.split(" ", trim: true)
    |> Enum.map(fn (str) -> mapping[str |> String.split("", trim: true) |> Enum.sort() |> Enum.join("")] end)
    |> Enum.join("")
    |> String.to_integer()
  end
end

# Test
# """
# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
# edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
# fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
# fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
# aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
# fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
# dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
# bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
# egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
# gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
# """
# |> String.split("\n", trim: true)
# |> Enum.map(&SevenSegment.decode/1)
# |> Enum.sum()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&SevenSegment.decode/1)
|> Enum.sum()
|> IO.inspect()
