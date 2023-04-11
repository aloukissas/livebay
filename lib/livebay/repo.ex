defmodule Livebay.Repo do
  use Ecto.Repo,
    otp_app: :livebay,
    adapter: Ecto.Adapters.Postgres
end
