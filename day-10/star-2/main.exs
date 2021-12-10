defmodule Syntax do

  @closing_braces [ ")", "]", "}", ">" ]
  @opening_braces [ "(", "[", "{", "<" ]
  @mapping        @closing_braces |> Enum.zip(@opening_braces) |> Enum.into(%{})
  @scores         @opening_braces |> Enum.zip([1,2,3,4]) |> Enum.into(%{})

  def find_incomplete_lines(input) do
    input
    |> Enum.map((&String.split(&1, "", trim: true)))
    |> Enum.reduce([], fn line, acc  ->
      case find_invalid_char(line) do
        {:ok, _invalid_char} -> acc
        {:err, incomplete_line} -> [incomplete_line | acc]
      end
    end)
    |> Enum.map(&Enum.slice(&1, 0..-2))
  end

  def calculate_score(incompletes) do
    incompletes
    |> Enum.map(fn (line) ->
      Enum.reduce(line, 0, fn (elem, acc) -> (acc * 5) + @scores[elem] end)
    end)
    |> Enum.sort()
    |> then(&Enum.at(&1, (length(&1) -1) |> div(2)))
  end

  defp find_invalid_char(input) do
    Enum.reduce_while(input, ["*"], &check_char/2)
    |> then(fn result -> if is_list(result), do: {:err, result}, else: {:ok, result} end)
  end

  defp check_char(current, [last_open | prev_open] = open_braces) do
    is_closing_brace = Enum.member?(@closing_braces, current)

    cond do
      is_closing_brace && last_open == @mapping[current] -> {:cont, prev_open}
      is_closing_brace                                   -> {:halt, current}
      true                                               -> {:cont, [ current | open_braces ]}
    end
  end
end

# Test
#"""
#[({(<(())[]>[[{[]{<()<>>
#[(()[<>])]({[<{<<[]>>(
#{([(<{}[<>[]}>{[]{[(<()>
#(((({<>}<{<{<>}{[]{[]{}
#[[<[([]))<([[{}[[()]]]
#[{[{({}]{}}([{[{{{}}([]
#{<[[]]>}<{[{[{[]{()[[[]
#[<(<(<(<{}))><([]([]()
#<{([([[(<>()){}]>(<<{{
#<{([{{}}[<[[[<>{}]]]>[]]
#"""
#|> String.split("\n", trim: true)
#|> Syntax.find_incomplete_lines()
#|> Syntax.calculate_score()
#|> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Syntax.find_incomplete_lines()
|> Syntax.calculate_score()
|> IO.inspect()
