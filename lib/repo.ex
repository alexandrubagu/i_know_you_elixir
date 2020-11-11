defmodule IKnowYou.Repo do
  use Ecto.Repo,
    otp_app: :i_know_you_elixir,
    adapter: Ecto.Adapters.Postgres
end
