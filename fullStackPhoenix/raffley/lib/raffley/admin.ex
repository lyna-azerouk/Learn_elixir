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
end