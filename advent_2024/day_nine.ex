defmodule DayNine do
  def run do
    "day_nine.txt"
    |> File.read()
    |> case do
      {:ok, content} ->
        content
        |> process_disk_map()
        |> IO.inspect(label: "Checksum")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end

  defp process_disk_map(content) do
    disk_map =
      content
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    blocks = parse_disk_map(disk_map)

    compacted_blocks = compact_blocks(blocks)

    calculate_checksum(compacted_blocks)
  end

  defp parse_disk_map(disk_map) do
    Enum.reduce(disk_map, {[], 0, true}, fn length, {acc, file_id, is_file} ->
      case is_file do
        true ->
          {acc ++ List.duplicate(file_id, length), file_id + 1, false}

        false ->
          {acc ++ List.duplicate(".", length), file_id, true}
      end
    end)
    |> elem(0)
  end

  defp compact_blocks(blocks) do
    Enum.reduce_while(0..(length(blocks) - 1), blocks, fn _, acc ->
      case move_file_block(acc) do
        {:ok, new_blocks} -> {:cont, new_blocks}
        :done -> {:halt, acc}
      end
    end)
  end

  defp move_file_block(blocks) do
    case Enum.find_index(blocks, &(&1 == ".")) do
      nil -> :done
      free_space_index ->
        rightmost_file_index =
          Enum.reverse(blocks)
          |> Enum.find_index(&(&1 != "."))
          |> case do
            nil -> :done
            index -> length(blocks) - 1 - index
          end

        if rightmost_file_index > free_space_index do
          blocks = List.replace_at(blocks, free_space_index, Enum.at(blocks, rightmost_file_index))
          blocks = List.replace_at(blocks, rightmost_file_index, ".")
          {:ok, blocks}
        else
          :done
        end
    end
  end

  defp calculate_checksum(blocks) do
    blocks
    |> Enum.with_index()
    |> Enum.reduce(0, fn
      {".", _}, acc -> acc
      {file_id, index}, acc -> acc + file_id * index
    end)
  end
end

DayNine.run()
