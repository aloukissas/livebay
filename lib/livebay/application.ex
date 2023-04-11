defmodule Livebay.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LivebayWeb.Telemetry,
      # Start the Ecto repository
      Livebay.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Livebay.PubSub},
      # Start Finch
      {Finch, name: Livebay.Finch},
      # Start the Endpoint (http/https)
      LivebayWeb.Endpoint
      # Start a worker by calling: Livebay.Worker.start_link(arg)
      # {Livebay.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Livebay.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LivebayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
