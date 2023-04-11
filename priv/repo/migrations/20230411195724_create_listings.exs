defmodule Livebay.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :title, :string
      add :description, :string
      add :photos, {:array, :string}
      add :min_bid_cents, :integer

      timestamps()
    end
  end
end
