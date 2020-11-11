defmodule IKnowYou.Web.FallbackController do
  @moduledoc false

  use IKnowYou.Web, :controller

  alias IKnowYou.Web.ErrorView

  def call(conn, {:error, :graph_not_found}) do
    conn
    |> put_status(404)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, error}) do
    conn
    |> put_status(422)
    |> put_view(ErrorView)
    |> render("unprocessable.json", error: error)
  end
end
