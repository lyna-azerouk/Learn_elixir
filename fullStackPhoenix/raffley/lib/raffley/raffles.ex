
defmodule Raffley.Raffle do
  defstruct [:id, :prize, :ticket_price, :image_path, :status, :description]
end

defmodule Raffley.Raffles do

  def list_raffles() do
    [
      %Raffley.Raffle{
        id: 1,
        prize: "$ prize1 $",
        ticket_price: 10,
        image_path: "/images/tree-down.jpg",
        status: "state1",
        description: "desc1"
      },
      %Raffley.Raffle{
        id: 2,
        prize: "$ prize2 $",
        ticket_price: 20,
        image_path: "/images/tree-down.jpg",
        status: "state2",
        description: "desc2"
      },
      %Raffley.Raffle{
        id: 3,
        prize: "$ prize3 $",
        ticket_price: 80,
        image_path: "/images/tree-down.jpg",
        status: "state3",
        description: "desc3"
      }
    ]
  end

  def get_raffel(id) when is_integer(id) do
    Enum.find(list_raffles(), fn r -> r.id == id end)
  end

  def get_raffel(id) when is_binary(id) do
    Enum.find(list_raffles(), fn r -> r.id == (id |> String.to_integer()) end)
  end

  def feature_raffles(raffle) do
    list_raffles() |> List.delete(raffle)
  end
end
