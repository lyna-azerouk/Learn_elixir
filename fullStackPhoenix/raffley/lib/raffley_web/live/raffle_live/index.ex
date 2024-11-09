defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponent

  def mount(_, _, socket) do
    socket = assign(socket, raffles: Raffles.list_raffles())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="raffle-index">
      <.banner :if={false}>
        <.icon name="hero-sparkles-solid" /> Soon
        <:details :let={vibe}>
          hello <%= vibe %>
        </:details>
         <:details>
          blalbla
        </:details>
      </.banner>
      <div class="raffles">
        <%= for raffle <- @raffles do %>
        <.raffle_card raffle={raffle}/>
        <% end %>
      </div>
    </div>
    """
  end

  def raffle_card(assigns) do
    ~H"""
      <div class="card">
        <img src={@raffle.image_path} />
        <h1> <%= @raffle.prize %> </h1>
        <div class="details">
          <div class="price">
            <h3> <%= @raffle.ticket_price %> </h3>
          </div>
          <.badge status={@raffle.status}/>
        </div>
      </div>
    """
  end

  # attr :status, :string, required: true  ## est appliquer uniquemnt a la fonction qui suit
  # ## To avoid compenent duplication
  # def badge(assigns) do
  #   ~H"""
  #     <div class={[
  #         "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
  #         @status=="state1" && "text-lime-600 border-lime-600",
  #         @status=="state2" && "text-lime-600 border-red-600",
  #         @status=="state3" && "text-lime-600 border-blue-600"
  #       ]}>
  #       <%= @status %>
  #     </div>
  #   """
  # end
end
