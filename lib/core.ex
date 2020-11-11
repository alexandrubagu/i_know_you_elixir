defmodule IKnowYou.Core do
  @moduledoc false

  alias IKnowYou.Core.Registry
  alias IKnowYou.Core.Validator
  alias IKnowYou.Core.State
  alias IKnowYou.Core.Supervisor

  @doc """
  Creates a new graph and returns associated id
  """
  def new_graph() do
    graph_id = Ecto.UUID.generate()

    with {:ok, _pid} <- Supervisor.new_graph(graph_id) do
      {:ok, graph_id}
    end
  end

  @doc """
  Creates a subgraph inside given graph id
  """
  def create_subgraph(graph_id, params) do
    with {:ok, graph_pid} <- Registry.get_graph_pid(graph_id),
         {:ok, validated_params} <- Validator.run(params) do
      State.create_subgraph(graph_pid, validated_params)
    end
  end

  @doc """
  Returns shortest possible path from vertex V1 to vertex V2 inside given graph id
  """
  def get_shortest_path(graph_id, v1, v2) do
    with {:ok, graph_pid} <- Registry.get_graph_pid(graph_id) do
      State.get_shortest_path(graph_pid, v1, v2)
    end
  end
end
