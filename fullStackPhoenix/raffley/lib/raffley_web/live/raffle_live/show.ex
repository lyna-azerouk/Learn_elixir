defmodule RaffleyWeb.RaffleLive.Show do
  use RaffleyWeb, :live_view

  alias  Raffley.Raffles
  import RaffleyWeb.CustomComponent

  def mount(_, _, socket) do
    # raffel = Raffles.get_raffel(id)

    # socket =
    #   socket
    #   |> assign(:raffel, raffel)
    #   |> assign(:page_title, raffel.prize)

    {:ok, socket}
  end


  def handle_params(%{"id" => id}, _uri, socket) do  ## handle_params est toujours appeler apres mount on peut donc definir les paramettre de la socket soit dans la fonction mount dirrectement soit dans hadel_params ==> une question de choix
    raffel = Raffles.get_raffel(id)
    feature_raffels = Raffles.feature_raffles(raffel)

    socket =
      socket
      |> assign(:raffel, raffel)
      |> assign(:feature_raffels, feature_raffels)
      |> assign(:page_title, raffel.prize)

    {:noreply, socket}
  end


  def render(assigns) do
    ~H"""
      <div class="raffle-show">
        <div class="raffle">
          <img  src={@raffel.image_path}>
          <section>
            <.badge status={@raffel.status} />
            <header>
              <h1> <%= @raffel.prize %> </h1>
              <p>  <%= @raffel.description %> </p>
            </header>
          </section>
        </div>
        <div class="activity">
          <div class="left">
            <div class="right">
              <.featured_raffels feature_raffels={@feature_raffels} />
            </div>
          </div>
        </div>
      </div>
    """
  end


  def featured_raffels(assigns) do
    ~H"""
     Fetured raffels
    <section>
      <ul class="raffles">
      <%= for raffel <- @feature_raffels do %>
          <li>
            <img  src={raffel.image_path}>  <h1> <%= raffel.prize %> </h1>
          </li>
        <% end %>
      </ul>
    </section>
    """
  end
end
