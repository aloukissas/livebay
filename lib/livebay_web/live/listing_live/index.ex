defmodule LivebayWeb.ListingLive.Index do
  use LivebayWeb, :live_view

  alias Livebay.Auctions
  alias Livebay.Auctions.Listing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :listings, Auctions.list_listings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Listing")
    |> assign(:listing, Auctions.get_listing!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Listing")
    |> assign(:listing, %Listing{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Listings")
    |> assign(:listing, nil)
  end

  @impl true
  def handle_info({LivebayWeb.ListingLive.FormComponent, {:saved, listing}}, socket) do
    {:noreply, stream_insert(socket, :listings, listing)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    listing = Auctions.get_listing!(id)
    {:ok, _} = Auctions.delete_listing(listing)

    {:noreply, stream_delete(socket, :listings, listing)}
  end
end
