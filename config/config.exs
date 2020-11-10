# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :i_know_you_elixir,
  namespace: IKnowYou,
  ecto_repos: [IKnowYou.Repo]

# Configures the endpoint
config :i_know_you_elixir, IKnowYouWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ovTJfJeTFs0ngTJGIbpBdNakK9s0/uOVPBrtSmvM6xAmWLkYPJtR0A3Q5ULXW6iS",
  render_errors: [view: IKnowYouWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: IKnowYou.PubSub,
  live_view: [signing_salt: "sIIHvmQm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
