defmodule Livebay.AuctionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Livebay.Auctions` context.
  """

  @doc """
  Generate a listing.
  """
  def listing_fixture(attrs \\ %{}) do
    {:ok, listing} =
      attrs
      |> Enum.into(%{
        description: "some description",
        min_bid_cents: 42,
        photos: ["option1", "option2"],
        title: "some title"
      })
      |> Livebay.Auctions.create_listing()

    listing
  end
end
