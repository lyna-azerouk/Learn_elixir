defmodule RaffleyWeb.AdminRaffelLive.Form do
alias Raffley.Rafles.Raffele
  use RaffleyWeb, :live_view

  alias Raffley.Admin

  def mount(params, _, socket) do
    socket = apply_action(socket, socket.assigns.live_action, params)

    {:ok, socket}
  end

  defp apply_action(socket, :new, _) do
    raffle = %Raffele{}
    changeset = Admin.change_raffel(raffle)  ##  to insert the default values on the form

    socket
    |> assign(:page_title, "New raffle")
    |> assign(form: to_form(changeset, as: "raffele"))
    |> assign(raffle: raffle)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    raffle = Admin.get_raffle!(id)
    changeset = Admin.change_raffel(raffle)

    socket
    |> assign(:page_title, "Edit raffle")
    |> assign(form: to_form(changeset, as: "raffele"))
    |> assign(raffle: raffle)
  end


  def handle_event("save", %{"raffele" => raffle_params}, socket) do
    save_raffle(socket, socket.assigns.live_action, raffle_params)
  end

  def handle_event("validate", %{"raffele" => raffle_params}, socket) do ## will print the errors each time an input is updated
    changeset = Admin.change_raffel(%Raffele{}, raffle_params)
    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end


  defp save_raffle(socket, :new, raffle_params) do
    Admin.create_raffle(raffle_params)
    |> case do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "OK saved")
          |> push_navigate( to: ~p"/admin/raffles")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = socket
          |> assign(:form, to_form(changeset))
          |> put_flash(:error, "Error")
        {:noreply, socket}
    end
  end

  defp save_raffle(socket, :edit, raffle_params) do
    Admin.update_raffle(socket.assigns.raffle, raffle_params)
    |> case do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "OK updated")
          |> push_navigate( to: ~p"/admin/raffles")
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = socket
          |> assign(:form, to_form(changeset))
          |> put_flash(:error, "Error")
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <.header>
      <%= @page_title %>
      <.simple_form for={@form} id="raffele-form" phx-submit="save" phx-change="validate">
        <.input field={@form[:prize]} label="Prize" phx-debounce="blur" />
        <.input field={@form[:description]} label="Description" type="textarea"  phx-debounce="blur"/>
        <.input field={@form[:ticket_price]} label="Ticket price" type="number" phx-debounce="blur"/>
        <.input field={@form[:status]} label="Status" type="select" options={[:upcoming, :open, :closed]} phx-debounce="blur"/>
        <.input field={@form[:image_path]} label="Image path" />

        <:actions>
          <.button class="mt-2">
            Save Raffle
          </.button>
        </:actions>
      </.simple_form>

      <.back navigate={~p"/admin/raffles"}>
      </.back>
    </.header>
    """
  end
end
