defmodule LiveViewStudio.Stores do
  def search_by_zip(zip) do
    :timer.sleep(2000)

    list_stores()
    |> Enum.filter(&(&1.zip == zip))
  end

  def search_by_city(city) do
    list_stores()
    |> Enum.filter(&(&1.city == city))
  end

  def list_stores do
    [
      %{
        name: "Downtown Helena",
        street: "312 Montana Avenue",
        phone_number: "23456789",
        city: "Helena, MT",
        zip: "2345678",
        open: true,
        hours: "8am - 10pm M-F"
      },
      %{
        name: "Denver West",
        street: "501 Mountain Lane",
        phone_number: "23456789",
        city: "Denver, CO",
        zip: "2345678",
        open: true,
        hours: "8am - 10pm M-F"
      }
    ]
  end
end
