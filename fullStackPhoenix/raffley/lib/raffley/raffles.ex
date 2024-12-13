defmodule Raffley.Raffles do

  alias Raffley.Rafles.Raffele
  alias Raffley. Repo
  import Ecto.Query

  # def list_raffles() do
  #   [
  #     %Raffele{
  #       prize: "$ prize1 $",
  #       ticket_price: 10,
  #       image_path: "/images/tree-down.jpg",
  #       status: :upcoming,
  #       description: "desc1"
  #     },
  #     %Raffele{
  #       prize: "$ prize2 $",
  #       ticket_price: 20,
  #       image_path: "/images/tree-down.jpg",
  #       status: :open,
  #       description: "desc2"
  #     },
  #     %Raffele{
  #       prize: "$ prize3 $",
  #       ticket_price: 80,
  #       image_path: "/images/tree-down.jpg",
  #       status: :closed,
  #       description: "desc3"
  #     }
  #   ]
  # end


  def list_raffles() do
    Repo.all(Raffele)
  end

  def get_raffel!(id) when is_binary(id) do
    id |> String.to_integer() |> get_raffel!()
  end

  # Raise an exception
  def get_raffel!(id) do
    Repo.get!(Raffele, id)
  end


  def filter_raffles(filter) do
    Raffele
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> sort_by(filter["sorted_by"])
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil],  do: query

  defp search_by(query, q) do
    where(query, [r], ilike( r.prize, ^"%#{q}%"))
  end

  defp sort_by(query, "prize") do
    query |> order_by(:prize)
  end

  defp sort_by(query, "ticket_price") do
    query |> order_by(:ticket_price)
  end

  defp sort_by(query, _), do: query

  def feature_raffles(raffle) do
    Raffele
    |> where(status: :open)
    |> where([r], r.id != ^raffle.id)
    |> order_by(desc: :ticket_price)
    |> Repo.all()
  end
end
