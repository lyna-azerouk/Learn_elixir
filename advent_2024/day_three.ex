defmodule DayThree do
  def run do
    "day_three.txt"
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        # |> get_result_part_one()
        |> get_result_part_two()
        |> IO.inspect(label: "Valid lists count")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  defp get_result_part_one(content) do
    Regex.scan(~r/mul\(\d+,\s*\d+\)/, content)
    |> Enum.reduce(0 , fn x, acc -> acc + get_mul(x) end)
  end

  defp get_mul([x]) do
    case Regex.run(~r/mul\((\d+),\s*(\d+)\)/, x) do
      [_, a, b] -> String.to_integer(a) * String.to_integer(b)
      _ -> 0
    end
  end

  defp get_result_part_two(content) do

  end
end

DayThree.run()
