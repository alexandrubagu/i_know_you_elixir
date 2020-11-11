defmodule IKnowYou.Core.State do
  @moduledoc false

  use GenServer

  alias IKnowYou.Core.Graph
  alias IKnowYou.Core.Registry

  def start_link(opts) do
    graph_id = Keyword.fetch!(opts, :graph_id)
    via_name = Registry.name(graph_id)
    GenServer.start_link(__MODULE__, opts, name: via_name)
  end

  def init(_opts), do: {:ok, Graph.new()}
  def create_subgraph(pid, params), do: GenServer.call(pid, {:create_subgraph, params})
  def get_shortest_path(pid, v1, v2), do: GenServer.call(pid, {:get_shortest_path, v1, v2})
  def get_vertices(pid), do: GenServer.call(pid, :get_vertices)
  def get_edges(pid), do: GenServer.call(pid, :get_edges)

  def handle_call({:create_subgraph, params}, _from, graph) do
    parent_name = params.name
    children_names = Enum.map(params.friends, & &1.name)

    parent = Graph.create_vertex(graph, parent_name)
    children = Graph.create_vertices(graph, children_names)
    Graph.create_edges(graph, parent, children)

    graph_data = %{nodes: Graph.get_vertices(graph), edges: Graph.get_edges(graph)}
    {:reply, {:ok, graph_data}, graph}
  end

  def handle_call({:get_shortest_path, v1, v2}, _from, graph) do
    {:reply, {:ok, Graph.get_shortest_path(graph, v1, v2)}, graph}
  end
end
