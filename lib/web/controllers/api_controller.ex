defmodule IKnowYou.Web.ApiController do
  @moduledoc false

  use IKnowYou.Web, :controller

  alias IKnowYou.Core

  action_fallback IKnowYou.Web.FallbackController

  def new(conn, _params) do
    with {:ok, graph_id} <- Core.new_graph() do
      json(conn, %{data: %{graph_id: graph_id}})
    end
  end

  def create_subgraph(conn, %{"graph_id" => graph_id, "subgraph" => subgraph_params}) do
    with {:ok, graph_data} <- Core.create_subgraph(graph_id, subgraph_params) do
      conn
      |> put_status(:created)
      |> json(%{data: graph_data})
    end
  end

  def get_shortest_path(conn, %{"graph_id" => graph_id, "from" => from, "to" => to}) do
    with {:ok, path} <- Core.get_shortest_path(graph_id, from, to) do
      json(conn, %{data: path})
    end
  end
end
