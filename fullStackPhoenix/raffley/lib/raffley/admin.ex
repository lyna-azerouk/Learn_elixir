defmodule Raffley.Admin do
  alias Raffley.Rafles.Raffele
  alias Raffley. Repo
  import Ecto.Query

  def list_raffles() do
    Raffele
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_raffle(attrs) do
    %Raffele{}
    |> Raffele.changeset(attrs)
    |> Repo.insert()
  end

  def change_raffel(raffel, attrs \\ %{}) do
    Raffele.changeset(raffel, attrs)
  end

  def get_raffle!(id) do
    Repo.get!(Raffele, id)
  end

  def update_raffle(raffel, attrs) do
    raffel
    |> Raffele.changeset(attrs)
    |> Repo.update()
  end

  def delete_raffel(raffel) do
    Repo.delete!(raffel)
  end
end
