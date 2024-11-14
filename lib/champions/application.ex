defmodule Champions.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChampionsWeb.Telemetry,
      Champions.Repo,
      {DNSCluster, query: Application.get_env(:champions, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Champions.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Champions.Finch},
      # Start a worker by calling: Champions.Worker.start_link(arg)
      # {Champions.Worker, arg},
      # Start to serve requests, typically the last entry
      ChampionsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Champions.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChampionsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
