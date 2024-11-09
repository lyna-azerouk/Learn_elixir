defmodule RaffleyWeb.CustomComponent do
  use RaffleyWeb, :html

  attr :status, :string, required: true  ## est appliquer uniquemnt a la fonction qui suit
  ## To avoid compenent duplication
  def badge(assigns) do
    ~H"""
      <div class={[
          "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
          @status=="state1" && "text-lime-600 border-lime-600",
          @status=="state2" && "text-lime-600 border-red-600",
          @status=="state3" && "text-lime-600 border-blue-600"
        ]}>
        <%= @status %>
      </div>
    """
  end

  slot :inner_block, required: true
  slot :details
  def banner(assigns) do
    assigns = assign(assigns, emoji: ":)" )
    ~H"""
     <div class="banner">
      <h1>
        <%= render_slot(@inner_block) %>
       </h1>

       <div :if={@details != []} class="details" >
          <%= render_slot(@details, @emoji) %>
      </div>
     </div>
    """
  end
end
