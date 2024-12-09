defmodule DayFive do

  def run do
    "day_five.txt"
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        |> get_result_part_one()
        |> IO.inspect(label: "Valid lists count")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  defp get_result_part_one(content) do
    String.split(content, ~r/\n\s*\n/)
    |> case do
      [_head | _rest ] = result -> result |> get_result()

        _ -> nil
    end
  end


  defp get_result([ rules | [content]]) do
    content
    |> String.split(~r/\n/)
    |> Enum.reduce(0, fn sequence, acc ->
       if is_valid?(rules, sequence |> String.split(~r/\,/)) do
        acc + get_middle(sequence)
      else
        acc + 0
      end
    end)
  end

  defp is_valid?(_, nil), do: true
  defp is_valid?(_, [_]), do: true

  defp is_valid?(rules, sequence) do
    sequence
    |> case do
      [x | rest ] ->
        if respects_rules(x, rest, rules |> String.split(~r/\n/)) do
          is_valid?(rules, rest)
        else
          false
        end

        _ -> true
    end
  end

  defp respects_rules(x, rest, rules) do
    Enum.all?(rest, fn el -> find_rule(rules, x, el) end)
  end

  defp find_rule(nil, _, _), do: false

  defp find_rule(rules, x, el) do
    rules
    |> case do
      [head | rest ] ->
        head
        |> String.split("|")
        |> case do
          [ part1, part2 ] ->
            if (String.to_integer(part1) == String.to_integer(x)) && (String.to_integer(part2) == String.to_integer(el)) do
              true
            else
              find_rule(rest, x, el)
            end
          _ -> false
        end
      _ -> false
    end
  end

  defp get_middle(sequence) when is_binary(sequence) do
    result =
      sequence
      |> String.split(~r/,/)

    index = div(Enum.count(result), 2)

    result
    |> Enum.at(index)
    |> String.to_integer()
  end
end

DayFive.run()
