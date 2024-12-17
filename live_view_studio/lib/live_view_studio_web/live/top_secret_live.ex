defmodule LiveViewStudioWeb.TopSecretLive do
  use LiveViewStudioWeb, :live_view

  on_mount {LiveViewStudioWeb.UserAuth, :ensure_authenticated}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="top-secret">
      <div class="mission">
        <h1>Top Secret</h1>
        <h2>Your Mission</h2>
        <h3>00<%= @current_user.id %></h3>
        <p>
         ****************************************************
        </p>
      </div>
    </div>
    """
  end
end
