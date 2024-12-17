defmodule LiveViewStudioWeb.SalesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)  ###  to send a message to the proess liveview it self every 1 second
    end

    {:ok, assign_stats(socket)}
  end

  def handle_event("refresh", _, socket) do
    {:noreply, assign_stats(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, assign_stats(socket)}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end

  def render(assigns) do
    ~H"""
    <h1>Snappy Sales 📊</h1>
    <div id="sales">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="label">
             Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="label">
             Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="label">
            satisfaction
          </span>
        </div>
      </div>

      <button phx-click="refresh">
        Refresh
      </button>
    </div>
    """
  end
end
