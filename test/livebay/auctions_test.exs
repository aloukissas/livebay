defmodule Livebay.AuctionsTest do
  use Livebay.DataCase

  alias Livebay.Auctions

  describe "listings" do
    alias Livebay.Auctions.Listing

    import Livebay.AuctionsFixtures

    @invalid_attrs %{description: nil, min_bid_cents: nil, photos: nil, title: nil}

    test "list_listings/0 returns all listings" do
      listing = listing_fixture()
      assert Auctions.list_listings() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Auctions.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      valid_attrs = %{description: "some description", min_bid_cents: 42, photos: ["option1", "option2"], title: "some title"}

      assert {:ok, %Listing{} = listing} = Auctions.create_listing(valid_attrs)
      assert listing.description == "some description"
      assert listing.min_bid_cents == 42
      assert listing.photos == ["option1", "option2"]
      assert listing.title == "some title"
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auctions.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      update_attrs = %{description: "some updated description", min_bid_cents: 43, photos: ["option1"], title: "some updated title"}

      assert {:ok, %Listing{} = listing} = Auctions.update_listing(listing, update_attrs)
      assert listing.description == "some updated description"
      assert listing.min_bid_cents == 43
      assert listing.photos == ["option1"]
      assert listing.title == "some updated title"
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Auctions.update_listing(listing, @invalid_attrs)
      assert listing == Auctions.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Auctions.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Auctions.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Auctions.change_listing(listing)
    end
  end
end
