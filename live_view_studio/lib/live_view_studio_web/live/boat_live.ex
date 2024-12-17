defmodule LiveViewStudioWeb.BoatsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats
  import LiveViewStudioWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{type: "", prices: []},
        boats: Boats.list_boats()
      )

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  defp type_options do
    [
      "All Types": "",
      Sailing: "sailing"
    ]
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}

    boats = Boats.list_boats(filter)

    {:noreply, assign(socket, boats: boats, filter: filter)}
  end

  def render(assigns) do
    ~H"""
    <h1>Daily Boat Rentals</h1>

    <.promo expiration={2}>
      Save 25% on rentals!
    </.promo>

    <div id="boats">

      <div class="boats">
        <.boat :for={boat <- @boats} boat={boat} />
      </div>
    </div>

    <.promo>
      Hurry, only 3 boats left!
    </.promo>
    """
  end


  def boat(assigns) do
    ~H"""
    <div class="boat">
      <img src={@boat.image} />
      <div class="content">
        <div class="model">
          <%= @boat.model %>
        </div>
        <div class="details">
          <span class="price">
            <%= @boat.price %>
          </span>
          <span class="type">
            <%= @boat.type %>
          </span>
        </div>
      </div>
    </div>
    """
  end
end
