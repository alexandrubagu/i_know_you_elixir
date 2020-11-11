defmodule IKnowYou.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      IKnowYou.Web.Telemetry,
      {Phoenix.PubSub, name: IKnowYou.PubSub},
      IKnowYou.Core.Supervisor,
      IKnowYou.Core.Registry,
      IKnowYou.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: IKnowYou.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    IKnowYou.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
