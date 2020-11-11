defmodule IKnowYou.Web.FrontendController do
  @moduledoc false

  use IKnowYou.Web, :controller

  def index(conn, _params), do: render(conn, "index.html")
end
