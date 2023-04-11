defmodule Livebay.Auctions.Listing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listings" do
    field :description, :string
    field :min_bid_cents, :integer
    field :photos, {:array, :string}
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:title, :description, :photos, :min_bid_cents])
    |> validate_required([:title, :description, :photos, :min_bid_cents])
  end
end
