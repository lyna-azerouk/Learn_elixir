defmodule Raffley.Rafles.Raffele do
  use Ecto.Schema
  import Ecto.Changeset

  schema "raffles" do
    field :status, Ecto.Enum, values: [:upcoming, :open, :closed]
    field :description, :string
    field :prize, :string
    field :ticket_price, :integer
    field :image_path, :string, default: "/images/snowplow-stuck.jpg"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(raffele, attrs) do
    raffele
    |> cast(attrs, [:prize, :description, :ticket_price, :status, :image_path])
    |> validate_required([:prize, :description, :ticket_price, :status, :image_path])
    |> validate_length(:description, min: 10)
    |> validate_number(:ticket_price, greater_than: 10)
  end
end
