
defmodule Raffley.Raffle do
  defstruct [:id, :prize, :ticket_price, :image_path, :status]
end

defmodule Raffley.Raffles do

  def list_raffles() do
    [
      %Raffley.Raffle{
        id: 1,
        prize: "$ prize1 $",
        ticket_price: 10,
        image_path: "/images/tree-down.jpg",
        status: "state1"
      },
      %Raffley.Raffle{
        id: 2,
        prize: "$ prize2 $",
        ticket_price: 20,
        image_path: "/images/tree-down.jpg",
        status: "state2"
      },
      %Raffley.Raffle{
        id: 3,
        prize: "$ prize3 $",
        ticket_price: 80,
        image_path: "/images/tree-down.jpg",
        status: "state3"
      }
    ]
  end
end
