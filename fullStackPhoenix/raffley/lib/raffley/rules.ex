defmodule Raffley.Rules do

  def list_rules() do
    [
      %{
        id: 1,
        text: "This is the first rule"
      },
      %{
        id: 2,
        text: "This is the second rule"
      },
      %{
        id: 3,
        text: "Have fun :)"
      }
    ]
  end

  def get_rule(id) when is_integer(id) do
    Enum.find(list_rules(), fn r -> r.id == id end)
  end

  def get_rule(id) when is_binary(id) do
    Enum.find(list_rules(), fn r -> r.id == (id |> String.to_integer()) end)
  end
end
