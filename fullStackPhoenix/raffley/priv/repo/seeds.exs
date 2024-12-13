# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Raffley.Repo.insert!(%Raffley.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Raffley.Repo
alias Raffley.Rafles.Raffele

%Raffele{
prize: "jersey1",
description: "Description",
ticket_price: 20,
status: :open,
image_path:  "/images/placeholder.jpg"
}
|> Repo.insert!()

%Raffele{
  prize: "jersey2",
  description: "Description1",
  ticket_price: 30,
  status: :closed,
  image_path:  "/images/snowplow-stuck.jpg"
}
|> Repo.insert!()

%Raffele{
  prize: "jersey3",
  description: "Description3",
  ticket_price: 10,
  status: :open,
  image_path:  "/images/bear-in-trash.jpg"
}
|> Repo.insert!()


%Raffele{
  prize: "jersey4",
  description: "Description4",
  ticket_price: 05,
  status: :open,
  image_path:  "/images/bear-in-trash.jpg"
}
|> Repo.insert!()


%Raffele{
  prize: "jersey5",
  description: "Description5",
  ticket_price: 110,
  status: :closed,
  image_path:  "/images/bear-in-trash.jpg"
}
|> Repo.insert!()


%Raffele{
  prize: "jersey6",
  description: "Description6",
  ticket_price: 105,
  status: :open,
  image_path:  "/images/bear-in-trash.jpg"
}
|> Repo.insert!()
