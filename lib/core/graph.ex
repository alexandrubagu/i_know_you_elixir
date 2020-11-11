defmodule IKnowYou.Core.Graph do
  @moduledoc false

  @behaviour IKnowYou.Core.Graph.Behaviour

  @implementation_module Application.compile_env(
                           :i_know_you_elixir,
                           IKnowYou.Core.Graph,
                           IKnowYou.Core.Graph.Erlang
                         )

  defmodule Behaviour do
    @moduledoc false

    @type graph :: term
    @type vertex :: term
    @type edge :: term

    @callback new() :: graph()
    @callback create_vertex(graph, term) :: vertex() | {:error, term}
    @callback create_vertices(graph(), [term]) :: [vertex()] | {:error, term}
    @callback create_edges(graph(), vertex(), [vertex()]) :: :ok | {:error, term}
    @callback get_shortest_path(graph(), vertex(), vertex()) :: [vertex()] | false
    @callback get_vertices(graph()) :: [vertex()]
    @callback get_edges(graph()) :: [%{required(:from) => vertex(), required(:to) => vertex()}]
  end

  @impl true
  defdelegate new(), to: @implementation_module

  @impl true
  defdelegate create_vertex(graph, vertex), to: @implementation_module

  @impl true
  defdelegate create_vertices(graph, vertices), to: @implementation_module

  @impl true
  defdelegate create_edges(graph, vertex, vertices), to: @implementation_module

  @impl true
  defdelegate get_shortest_path(graph, vertex1, vertex2), to: @implementation_module

  @impl true
  defdelegate get_vertices(graph), to: @implementation_module

  @impl true
  defdelegate get_edges(graph), to: @implementation_module
end
