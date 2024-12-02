defmodule DayTwo do

  def run do
    case File.read("day_two.txt") do
      {:ok, content} -> build_list(content)
        _  -> nil
    end
    |> Enum.count(fn x ->(is_sorted_acc?(x) || is_sorted_des?(x)) && is_safe?(x) end)
    |>IO.inspect()
  end

  defp build_list(content) do
    String.split(content, "\n")
    |> Enum.reduce([], fn x, acc -> acc ++ [(String.split(x, " "))] end)
  end

  defp is_safe?([head | rest ]) do
    case rest do
      [x | _] ->
        if abs(String.to_integer(x) - String.to_integer(head)) in [1, 2, 3] do
          is_safe?(rest)
        else
          false
        end
      _ -> true
      end
  end

  defp is_safe?(_), do: true

  defp is_sorted_acc?([x | rest]) do
    case rest do
      [y | _] ->
        if String.to_integer(x) < String.to_integer(y) do
          is_sorted_acc?(rest)
        else
          false
        end
      _ -> true
    end
  end

  defp is_sorted_des?([x | rest]) do
    case rest do
      [y | _] ->
        if String.to_integer(x) > String.to_integer(y) do
          is_sorted_des?(rest)
        else
          false
        end
      _ -> true
    end
  end
end

DayTwo.run()
