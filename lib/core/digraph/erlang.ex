defmodule IKnowYou.Core.Graph.Erlang do
  @moduledoc false

  def new(), do: :digraph.new()
  def create_vertex(graph, v), do: :digraph.add_vertex(graph, v)
  def create_vertices(graph, vs) when is_list(vs), do: Enum.map(vs, &create_vertex(graph, &1))
  def create_edges(graph, v, vs), do: Enum.each(vs, &:digraph.add_edge(graph, v, &1))
  def get_shortest_path(graph, v1, v2), do: :digraph.get_short_path(graph, v1, v2)

  def get_vertices({_, vertices, _edges, _neighbours, _cyclic} = _graph) do
    vertices |> :ets.tab2list() |> Enum.map(fn {label, _} -> %{id: label, label: label} end)
  end

  def get_edges({_, _vertices, edges, _neighbours, _cyclic} = _graph) do
    edges |> :ets.tab2list() |> Enum.map(fn {_, from, to, _} -> %{from: from, to: to} end)
  end
end
