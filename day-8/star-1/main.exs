defmodule SevenSegment do
  def find_target_numbers(input) do
    [_hints, output] = String.split(input, "|", trim: true)

    output
    |> String.split(" ", trim: true)
    |> Enum.filter(fn (string) -> Enum.member?([2, 3, 4, 7], String.length(string)) end)
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
# |> Enum.map(&SevenSegment.find_target_numbers/1)
# |> List.flatten()
# |> Enum.count()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.map(&SevenSegment.find_target_numbers/1)
|> List.flatten()
|> Enum.count()
|> IO.inspect()
