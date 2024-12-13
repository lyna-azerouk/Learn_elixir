defmodule RaffleyWeb.RaffleLive.Index do
  use RaffleyWeb, :live_view

  alias Raffley.Raffles
  import RaffleyWeb.CustomComponent

  def mount(_, _, socket) do
    # form = to_form(%{"q" => "", "status"=> "", "sorted_by" => "" })
    socket = attach_hook(socket, :log_stream, :after_render, fn
      socket ->
        IO.inspect(socket.assigns.streams.raffles, label: "after render")
        socket
    end)
    {:ok, socket}
  end

  def handle_params(params, _, socket) do
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(params))
      |> assign(form: to_form(params)) # by default parms is empty

    {:noreply, socket}
  end


  def handle_event("filter", params, socket) do
    # socket =
    #   socket
    #   |> stream(:raffles, Raffles.filter_raffles(params), reset: true)  we dont need this because it hepens on the function H_params

      params =
        params
        |> Map.take(~w(q status sorted_by))
        |> Map.reject(fn {_, value} -> value == "" end)

      socket = push_navigate(socket, to: ~p"/raffles?#{params}") ## push_navigate will kill the first liveview and create a new one, with mount is called so handel_params is called just affter th
      {:noreply, socket}
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

      <.filter_from form={@form} />

      <div class="raffles" id="raffles" phx-update="stream">
        <%= for {dom_id, raffle} <- @streams.raffles do %>
          <.raffle_card raffle={raffle} id={dom_id}/>
        <% end %>
      </div>
    </div>
    """
  end

  #FUNCTION; navigate ==> faster then href  ==> evite de faire une requette http, donc on a pas une deconection de la socket et un nouveau call a la fonction mount de la liveview show, mais directement a la fonction handel_params de la liveView.show
  def raffle_card(assigns) do
    ~H"""
      <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
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
      </.link>
    """
  end


  #phx-debounce makes it less reactive to avoid multipl queries to DB, it avoids a query evry time we time a caracter
  defp filter_from(assigns) do
    ~H"""
     <.form for={@form} id="filter-form" phx-change="filter">
        <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="1000"/>
        <.input type="select" field={@form[:status]} prompt="Status" options={[:upcoming, :open, :closed]}/>
        <.input type="select" field={@form[:sorted_by]} prompt="Sort By" options={[Prize: "prize", "Price: Hight to low": "ticket_price"]}/>
      </.form>
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
