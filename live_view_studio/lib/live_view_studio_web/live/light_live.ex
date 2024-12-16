defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Licenses

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10)}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <div id="light" class ="items-center">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <button phx-click="up">
        <img src="images/light-on.svg">
        light up
      </button>

      <button  phx-click="off">
        <img src="images/light-off.svg">
        light off
      </button>
    </div>
    """
  end
end
