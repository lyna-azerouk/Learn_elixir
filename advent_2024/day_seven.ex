defmodule DaySeven do
  def run do
    "day_seven.txt"
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        |> get_result_part_one()
        |> IO.inspect(label: "Day seven result =>")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  defp get_result_part_one(content) do
    content
    |> String.split(~r/\n/)
    |> Enum.reduce(0, fn line, acc ->
      acc + if is_valid?(line), do: get_value_to_match(line), else: 0
    end)

  end

  def is_valid?(line) do
    [result_to_match_str, numbers_str] = String.split(line, ~r/\: /)

    generate_operator_combinations(length(numbers_str |> String.split(~r/ /)))
    |> find_combinision(numbers_str, result_to_match_str)
  end

  defp get_value_to_match(line) do
    [result_to_match_str, _] = String.split(line, ~r/\: /)
    String.to_integer(result_to_match_str)
  end

  def generate_operator_combinations(n) do
    operators = ["+", "*"]
    operator_lists = List.duplicate(operators, n - 1)
    operator_lists
    |> Enum.reduce(fn list, acc ->
      for x <- acc, y <- list, do: [x , y]
    end)
  end

  defp find_combinision(nil, _, _), do: false
  defp find_combinision([], _, _), do: false

  defp find_combinision([first_combinision | rest_comb], numbers_str, result_to_match_str) do
    if is_equal?(first_combinision, numbers_str, result_to_match_str) do
      true
    else
      find_combinision(rest_comb, numbers_str, result_to_match_str)
    end
  end

  defp is_equal?(nil, _, _), do: false

  defp is_equal?(one_comb, numbers_str, result_to_match_str) do
    numbers_list = numbers_str |> String.split(~r/ /)

    one_comb_flat =
      case one_comb do
        [_head | _rest] -> one_comb |> List.flatten()
        _ -> [one_comb]
      end

    result =
      Enum.reduce(0..Enum.count(numbers_list) - 2, 0, fn index, acc ->
        case {Enum.at(one_comb_flat, index), acc} do
          {"+", 0} ->
            acc + String.to_integer(Enum.at(numbers_list, index)) + String.to_integer(Enum.at(numbers_list, index + 1))
          {"*", 0} ->
            acc + String.to_integer(Enum.at(numbers_list, index)) * String.to_integer(Enum.at(numbers_list, index + 1))

          {"+", _} ->
            acc + String.to_integer(Enum.at(numbers_list, index + 1))

          {"*", _} ->
            acc * String.to_integer(Enum.at(numbers_list, index + 1))
        end
      end)

    result == String.to_integer(result_to_match_str)
  end
end

DaySeven.run()
