defmodule LiveViewStudioWeb.LiveViewStudioWeb.SearchLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Stores


  def mount(_, _, socket) do
    socket = assign(socket, zip: "", stores: [], loading: false )

    {:ok, socket}
  end


  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})

    updated_socket =
      socket
      |> assign(zip: zip, stores: [], loading: true)

    {:noreply, updated_socket}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    stores = Stores.search_by_zip(zip)

    updated_socket =
      case stores do
        [] ->
          socket
          |> put_flash(:info, "No stores found for \"#{zip}\"")
          |> assign(stores: [], loading: false)

        _ ->
          socket
          |> assign(stores: stores, loading: false)
      end

    {:noreply, updated_socket}
  end


  def render(assigns) do
    ~H"""
    <h1>Find a Store</h1>
    <div id="search">
      <form id="zip-search" phx-submit="zip-search">
        <input type="text" name="zip" value={@zip}
               placeholder="Zip Code"
               readonly={@loading} />

        <button type="submit">
        Submmit
        </button>
      </form>

      <%= if @loading do %>
        <div class="loader">
          Loading...
        </div>
      <% end %>

      <div class="stores">
        <ul>
          <%= for store <- @stores do %>
            <li>
              <div class="first-line">
                <div class="name">
                  <%= store.name %>
                </div>
                <div class="status">
                  <%= if store.open do %>
                    <span class="open">Open</span>
                  <% else %>
                    <span class="closed">Closed</span>
                  <% end %>
                </div>
              </div>
              <div class="second-line">
                <div class="street">
                  <%= store.street %>
                </div>
                <div class="phone_number">
                  <%= store.phone_number %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
