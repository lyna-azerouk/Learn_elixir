defmodule DayTwo do
  def run do
    "day_two.txt"
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        |> parse_input()
        |> count_valid_lists()
        |> IO.inspect(label: "Valid lists count")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  defp parse_input(content) do
    content
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
  end

  defp count_valid_lists(lists) do
    Enum.count(lists, &valid_list?/1)
  end

  defp valid_list?(list) do
    (is_sorted_asc?(list) || is_sorted_desc?(list)) && is_safe?(list)
  end

  defp is_safe?([head | rest]) do
    Enum.reduce_while(rest, String.to_integer(head), fn x, prev ->
      x_int = String.to_integer(x)

      if abs(x_int - prev) in [1, 2, 3] do
        {:cont, x_int}
      else
        {:halt, false}
      end
    end) !== false
  end

  defp is_safe?([]), do: true

  defp is_sorted_asc?([x | rest]), do: check_sorted(rest, String.to_integer(x), &<=/2)
  defp is_sorted_desc?([x | rest]), do: check_sorted(rest, String.to_integer(x), &>=/2)

  defp check_sorted([], _prev, _cmp), do: true

  defp check_sorted([x | rest], prev, cmp) do
    current = String.to_integer(x)

    if cmp.(prev, current) do
      check_sorted(rest, current, cmp)
    else
      false
    end
  end
end

DayTwo.run()
