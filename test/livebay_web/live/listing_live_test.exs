defmodule LivebayWeb.ListingLiveTest do
  use LivebayWeb.ConnCase

  import Phoenix.LiveViewTest
  import Livebay.AuctionsFixtures

  @create_attrs %{description: "some description", min_bid_cents: 42, photos: ["option1", "option2"], title: "some title"}
  @update_attrs %{description: "some updated description", min_bid_cents: 43, photos: ["option1"], title: "some updated title"}
  @invalid_attrs %{description: nil, min_bid_cents: nil, photos: [], title: nil}

  defp create_listing(_) do
    listing = listing_fixture()
    %{listing: listing}
  end

  describe "Index" do
    setup [:create_listing]

    test "lists all listings", %{conn: conn, listing: listing} do
      {:ok, _index_live, html} = live(conn, ~p"/listings")

      assert html =~ "Listing Listings"
      assert html =~ listing.description
    end

    test "saves new listing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/listings")

      assert index_live |> element("a", "New Listing") |> render_click() =~
               "New Listing"

      assert_patch(index_live, ~p"/listings/new")

      assert index_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#listing-form", listing: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/listings")

      html = render(index_live)
      assert html =~ "Listing created successfully"
      assert html =~ "some description"
    end

    test "updates listing in listing", %{conn: conn, listing: listing} do
      {:ok, index_live, _html} = live(conn, ~p"/listings")

      assert index_live |> element("#listings-#{listing.id} a", "Edit") |> render_click() =~
               "Edit Listing"

      assert_patch(index_live, ~p"/listings/#{listing}/edit")

      assert index_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#listing-form", listing: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/listings")

      html = render(index_live)
      assert html =~ "Listing updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes listing in listing", %{conn: conn, listing: listing} do
      {:ok, index_live, _html} = live(conn, ~p"/listings")

      assert index_live |> element("#listings-#{listing.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#listings-#{listing.id}")
    end
  end

  describe "Show" do
    setup [:create_listing]

    test "displays listing", %{conn: conn, listing: listing} do
      {:ok, _show_live, html} = live(conn, ~p"/listings/#{listing}")

      assert html =~ "Show Listing"
      assert html =~ listing.description
    end

    test "updates listing within modal", %{conn: conn, listing: listing} do
      {:ok, show_live, _html} = live(conn, ~p"/listings/#{listing}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Listing"

      assert_patch(show_live, ~p"/listings/#{listing}/show/edit")

      assert show_live
             |> form("#listing-form", listing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#listing-form", listing: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/listings/#{listing}")

      html = render(show_live)
      assert html =~ "Listing updated successfully"
      assert html =~ "some updated description"
    end
  end
end
