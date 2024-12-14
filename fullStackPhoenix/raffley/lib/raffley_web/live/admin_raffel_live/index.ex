defmodule RaffleyWeb.AdminRaffelLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Admin #we can use the rafless context but it is better to use a a specific context to this live_view (admin)
  import RaffleyWeb.CustomComponent

  def mount(_prams, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "admin")
      |> stream(:raffels, Admin.list_raffles())

    {:ok, socket}
  end

  #phx-update and id will automaticlly be added to the table if we dont use <./table> we nedd to add them
  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        <%= @page_title %>
        <:actions>
          <.link  navigate={~p"/admin/raffles/new"} class="button">
            New
          </.link>
        </:actions>
      </.header>
      <.table id="raffels" rows={@streams.raffels}>
        <:col :let={{_dom_id, raffle}}  label="Prize">
          <.link  navigate={~p"/raffles/#{raffle}"} >
            <%= raffle.prize %>
          </.link>
        </:col>
        <:col :let={{_dom_id, raffle}}  label="Status">
          <.badge status={raffle.status} />
        </:col>
        <:col :let={{_dom_id, raffle}}  label="Ticket Price">
          <%= raffle.ticket_price %>
        </:col>
      </.table>
    </div>
    """
  end
end
