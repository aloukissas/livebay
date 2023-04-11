defmodule LivebayWeb.ListingLive.FormComponent do
  use LivebayWeb, :live_component

  alias Livebay.Auctions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage listing records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="listing-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input
          field={@form[:photos]}
          type="select"
          multiple
          label="Photos"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <.input field={@form[:min_bid_cents]} type="number" label="Min bid cents" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Listing</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{listing: listing} = assigns, socket) do
    changeset = Auctions.change_listing(listing)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"listing" => listing_params}, socket) do
    changeset =
      socket.assigns.listing
      |> Auctions.change_listing(listing_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"listing" => listing_params}, socket) do
    save_listing(socket, socket.assigns.action, listing_params)
  end

  defp save_listing(socket, :edit, listing_params) do
    case Auctions.update_listing(socket.assigns.listing, listing_params) do
      {:ok, listing} ->
        notify_parent({:saved, listing})

        {:noreply,
         socket
         |> put_flash(:info, "Listing updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_listing(socket, :new, listing_params) do
    case Auctions.create_listing(listing_params) do
      {:ok, listing} ->
        notify_parent({:saved, listing})

        {:noreply,
         socket
         |> put_flash(:info, "Listing created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
