defmodule RaffleyWeb.EstimatorLive do
  use RaffleyWeb, :live_view


  # this function is called tow times when server is desconect than a second tume whn the brower is connected to the websocet
  def mount(_params, _session, socket) do  #Contrairemnt a un controlleur une lieve ne recoi pas de plug mais plutot une socket

    if connected?(socket) do
      ## we are sure that it is the seond time that the function mount is called so the brouser is connected to the websocket
      Process.send_after(self(), :tick, 2000) # send a message to the liveview itself
    end

    socket = assign(socket, tickets: 0, price: 3, page_title: "Estimator")
    IO.inspect(self(), label: "mOUNT")
    # {:ok, socket, layout: {RaffleyWeb.Layouts, :simple}}
     {:ok, socket}
  end

  def handle_event("add", %{"qte"=> qte}, socket) do
    tickets = socket.assigns.tickets + 1
    IO.inspect(self(), label: "aDD")
    # socket = assign(socket, tickets: tickets)
    socket = update(socket, :tickets,  &(&1 + (qte |> String.to_integer())))
    {:noreply, socket}
  end

  def handle_event("set-price", %{"price"=> price}, socket) do
    IO.inspect("****************")
    IO.inspect(price)
    socket = assign(socket, price: (price |> String.to_integer()))
    {:noreply, socket}
  end


  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)
    {:noreply, update(socket, :tickets, &(&1 + 10))}
  end


  ##A la place de render on peut creer un fichier (estimator_live.html.heex) qui permetra de renvoyer la view on a deux écoles
  # Si le fonction render n'est pas définie alors par dfaut phonix va chercher le fichier (estimator_live.html.heex
  def render(assigns) do
    IO.inspect(self(), label: "Render")

    ~H"""
      <div class="estimator">
        <h1> Hello Estimator </h1>
        <section>
        <button phx-click="add" phx-value-qte="5">
          +
        </button>
        <div>
          $<%= @tickets %>
        </div>
        *
        <div>
          <%= assigns.price %>
        </div>
        =
        $ <%= assigns.tickets * assigns.price %>
        </section>

        <form phx-submit="set-price">
          <label> Tickets  </label>
          <input type="number" value={@price}  name="price"/>
        </form>
      </div>
    """
  end
end
