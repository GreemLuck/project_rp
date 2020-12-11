defmodule ProjectRp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ProjectRp.Repo,
      # Start the Telemetry supervisor
      ProjectRpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ProjectRp.PubSub},
      # Start the Endpoint (http/https)
      ProjectRpWeb.Endpoint,
      # Start a worker by calling: ProjectRp.Worker.start_link(arg)
      # {ProjectRp.Worker, arg}
      {ProjectRp.MessageHandler, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProjectRp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ProjectRpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
