defmodule RaffleyWeb.RuleController do
  use RaffleyWeb, :controller

  alias Raffley.Rules
  def index(conn, _params) do
    welcome = ~w(💚 💜 💙) |> Enum.random() |> String.duplicate(5)

    rules = Rules.list_rules()
    render(conn, :index, welcome: welcome, rules: rules)
  end


  def show(conn, %{"id"=> id}) do
    # raise inspect(prams) ## params will always be string !!!
    rule =Rules.get_rule(id)
    render(conn, :show, rule: rule)
  end
end
