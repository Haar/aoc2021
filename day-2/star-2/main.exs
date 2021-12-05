defmodule Submarine do
  def calculate_destination(instructions) do
    instructions
    |> Enum.reduce({0, 0, 0}, &apply_instruction/2)
    |> Tuple.delete_at(2)
    |> Tuple.product()
  end

  def apply_instruction(instruction, {x, y, aim}) do
    [direction, magnitude] = String.split(instruction, " ", trim: true)

    magnitude = String.to_integer(magnitude)

    case direction do
      "up"      -> {x, y, aim - magnitude}
      "down"    -> {x, y, aim + magnitude}
      "forward" -> {x + magnitude, y + (magnitude * aim), aim}
    end
  end
end

# Test
# """
# forward 5
# down 5
# forward 8
# up 3
# down 8
# forward 2
# """
# |> String.split("\n", trim: true)
# |> Submarine.calculate_destination()
# |> IO.puts()

"./input.txt"
|> File.stream!()
|> Enum.map(&String.trim/1)
|> Submarine.calculate_destination()
|> IO.puts()
