defmodule Syntax do

  @closing_braces [ ")", "]", "}", ">" ]
  @mapping        @closing_braces |> Enum.zip([ "(", "[", "{", "<" ]) |> Enum.into(%{})
  @scores         @closing_braces |> Enum.zip([3, 57, 1197, 25137])   |> Enum.into(%{})

  def find_invalid_lines(input) do
    input
    |> Enum.map((&String.split(&1, "", trim: true)))
    |> Enum.map(&find_invalid_char/1)
    |> Enum.reject(&is_nil/1)
  end

  def calculate_score(invalids) do
    invalids
    |> Enum.map((&@scores[&1]))
    |> Enum.sum()
  end

  defp find_invalid_char(input) do
    Enum.reduce_while(input, ["*"], &check_char/2)
    |> then(fn result -> if is_list(result), do: nil, else: result end)
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
# """
# [({(<(())[]>[[{[]{<()<>>
# [(()[<>])]({[<{<<[]>>(
# {([(<{}[<>[]}>{[]{[(<()>
# (((({<>}<{<{<>}{[]{[]{}
# [[<[([]))<([[{}[[()]]]
# [{[{({}]{}}([{[{{{}}([]
# {<[[]]>}<{[{[{[]{()[[[]
# [<(<(<(<{}))><([]([]()
# <{([([[(<>()){}]>(<<{{
# <{([{{}}[<[[[<>{}]]]>[]]
# """
# |> String.split("\n", trim: true)
# |> Syntax.find_invalid_lines()
# |> Syntax.calculate_score()
# |> IO.inspect()

"./input.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Syntax.find_invalid_lines()
|> Syntax.calculate_score()
|> IO.inspect()
