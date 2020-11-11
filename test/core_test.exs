defmodule IKnowYou.CoreTest do
  use IKnowYou.DataCase

  alias IKnowYou.Core

  describe "new/0" do
    test "return an unique id assigned with a graph" do
      assert {:ok, id} = Core.new_graph()
      assert is_binary(id)
    end
  end

  describe "create_subgraph/2" do
    @valid_params %{name: "a", friends: [%{name: "b"}, %{name: "c"}]}
    @invalid_params %{name: nil, friends: [%{}]}

    setup do
      {:ok, graph_id} = Core.new_graph()
      {:ok, graph_id: graph_id}
    end

    test "creates a subgraph using provided graph id", %{graph_id: graph_id} do
      assert {:ok, %{edges: edges, nodes: nodes}} = Core.create_subgraph(graph_id, @valid_params)
      assert %{from: "a", to: "b"} in edges
      assert %{from: "a", to: "c"} in edges
      assert %{id: "b", label: "b"} in nodes
      assert %{id: "c", label: "c"} in nodes
      assert %{id: "a", label: "a"} in nodes
    end

    test "returns an error when passing invalid params", %{graph_id: graph_id} do
      assert {:error, changeset} = Core.create_subgraph(graph_id, @invalid_params)
      assert "can't be blank" in errors_on(changeset)[:name]
      assert %{name: ["can't be blank"]} in errors_on(changeset)[:friends]
    end

    test "returns an error when graph doesn't exists" do
      assert {:error, :graph_not_found} = Core.create_subgraph(52, @invalid_params)
    end
  end

  describe "get_shortest_path/3" do
    @sub1 %{name: "a", friends: [%{name: "b"}, %{name: "c"}]}
    @sub2 %{name: "b", friends: [%{name: "e"}]}
    @sub3 %{name: "c", friends: [%{name: "d"}, %{name: "e"}]}

    setup do
      {:ok, graph_id} = Core.new_graph()
      {:ok, graph_id: graph_id}
    end

    test "returns the shortest path", %{graph_id: graph_id} do
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub1)
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub2)
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub3)

      assert {:ok, ["a", "b", "e"]} == Core.get_shortest_path(graph_id, "a", "e")
    end

    test "return false if there's no path", %{graph_id: graph_id} do
      assert {:ok, false} == Core.get_shortest_path(graph_id, "x", "y")
    end

    test "returns an error when graph doesn't exists" do
      assert {:error, :graph_not_found} = Core.get_shortest_path(52, "a", "e")
    end
  end
end
