defmodule DayNine do

  def run do
    "day_nine.txt"
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

   {formated_list, _, _} =
    content
    |> String.split(~r/\n/)
    |> case do
      [x] ->
        x
        |> String.split(~r//, trim: true)
        |> Enum.reduce({"", 0, 0}, fn number, {acc, index, number_to_print} ->
          case rem(index, 2) do
            0 -> {acc <> String.duplicate(Integer.to_string(number_to_print), String.to_integer(number)), index + 1, number_to_print + 1}
            1 -> { acc <> String.duplicate(".", String.to_integer(number)), index + 1, number_to_print}
          end
        end)

        _ -> nil
    end

    formated_list =
      formated_list
      |> String.split(~r//, trim: true)

    lenght_formated_list = length(formated_list)

    formated_list_bis = formated_list
    number_numbers = Enum.count(formated_list, fn x -> x != "." end)

    {result, _, _} =
      formated_list
      |> Enum.reduce_while({"", formated_list_bis, lenght_formated_list - 1}, fn e, {acc, formated_list_bis, index} ->
        case e do
          "." ->
            e_c = Enum.at(formated_list_bis, index)

            case e_c do
              nil ->
                {:halt, {acc, formated_list_bis, index}}

              _ ->
                formated_list_bis = formated_list_bis |> clean_list()
                {:cont, {acc <> e_c, formated_list_bis, length(formated_list_bis) - 1 }}
            end

          _ ->
            {:cont, {acc <> e, formated_list_bis, index}}
        end
      end)


      base = String.length(result)
      start_index = max(0, base - number_numbers)
      String.slice(result, 0, number_numbers)
      |> String.split(~r//, trim: true)
      |> Enum.reduce({0, 0}, fn el, {acc, index} -> {acc + index * String.to_integer(el), index + 1}
      end)
  end


  defp clean_list(list) do
    list
    |> Enum.drop(-1)
    |> remove_trailing_dots()
  end

  def remove_trailing_dots([]), do: []
  def remove_trailing_dots(list) do
    Enum.reverse(drop_dots(Enum.reverse(list)))
  end

  defp drop_dots(["." | tail]), do: drop_dots(tail)
  defp drop_dots(rest), do: rest

end

DayNine.run()
