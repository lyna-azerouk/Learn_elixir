defmodule DayOne do

  def run do
    case File.read("test.txt") do
      {:ok, content} -> build_left_right_list(content)
        _  -> nil
    end
    # |> get_the_result_part_one()
    |> get_the_result_part_two()
    |> IO.inspect()
  end

  defp build_left_right_list(content) do
    result = String.split(content, "\n")
    left =
      Enum.reduce(result, [], fn x, acc -> acc ++ [List.first(String.split(x, "  "))] end)
        |> Enum.sort()
    right =
      Enum.reduce(result, [], fn x, acc -> acc ++ [List.last(String.split(x, "   "))] end)
       |> Enum.sort()

    {left, right}
  end

  defp get_the_result_part_one({left, right}) do
    Enum.zip(left, right)
    |> Enum.reduce(0, fn tpl, acc -> acc + get_the_diffrence(tpl) end)
  end

  defp get_the_diffrence({fst, snd}) do
    abs(String.to_integer(fst) - String.to_integer(snd))
  end

  defp get_the_result_part_two({left, right}) do
    left
    |> Enum.reduce(0, fn x, acc -> acc + String.to_integer(x) * get_occurence(x, right) end)
  end

  defp get_occurence(number, right) do
    Enum.count(right, fn x -> x == number end)
  end
end

DayOne.run()
