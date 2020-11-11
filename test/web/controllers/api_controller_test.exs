defmodule IKnowYou.Web.ApiControllerTest do
  use IKnowYou.Web.ConnCase, async: true

  alias IKnowYou.Core

  describe "new" do
    test "return an unique id assigned with a graph", %{conn: conn} do
      assert %{"data" => %{"graph_id" => graph_id}} =
               conn
               |> post(Routes.api_path(conn, :new))
               |> json_response(200)

      assert is_binary(graph_id)
    end
  end

  describe "create_subgraph" do
    @valid_params %{name: "a", friends: [%{name: "b"}, %{name: "c"}]}
    @invalid_params %{name: nil, friends: [%{}]}

    setup do
      {:ok, graph_id} = Core.new_graph()
      {:ok, graph_id: graph_id}
    end

    test "creates a subgraph using provided graph id", %{conn: conn, graph_id: graph_id} do
      assert %{"data" => %{"edges" => edges, "nodes" => nodes}} =
               conn
               |> post(Routes.api_path(conn, :create_subgraph, graph_id), subgraph: @valid_params)
               |> json_response(201)

      assert %{"from" => "a", "to" => "b"} in edges
      assert %{"from" => "a", "to" => "c"} in edges
      assert %{"id" => "b", "label" => "b"} in nodes
      assert %{"id" => "c", "label" => "c"} in nodes
      assert %{"id" => "a", "label" => "a"} in nodes
    end

    test "returns an error when passing invalid params", %{conn: conn, graph_id: graph_id} do
      assert %{"error" => %{"message" => "Unprocessable Entity", "details" => details}} =
               conn
               |> post(Routes.api_path(conn, :create_subgraph, graph_id),
                 subgraph: @invalid_params
               )
               |> json_response(422)

      assert details == %{
               "friends" => [%{"name" => ["can't be blank"]}],
               "name" => ["can't be blank"]
             }
    end

    test "returns an error when graph doesn't exists", %{conn: conn} do
      assert "Not Found" =
               conn
               |> post(Routes.api_path(conn, :create_subgraph, 42), subgraph: @valid_params)
               |> json_response(404)
    end
  end

  describe "get_shortest_path" do
    @sub1 %{name: "a", friends: [%{name: "b"}, %{name: "c"}]}
    @sub2 %{name: "b", friends: [%{name: "e"}]}
    @sub3 %{name: "c", friends: [%{name: "d"}, %{name: "e"}]}

    setup do
      {:ok, graph_id} = Core.new_graph()
      {:ok, graph_id: graph_id}
    end

    test "returns the shortest path", %{conn: conn, graph_id: graph_id} do
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub1)
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub2)
      assert {:ok, _} = Core.create_subgraph(graph_id, @sub3)

      assert %{"data" => ["a", "b", "e"]} ==
               conn
               |> post(Routes.api_path(conn, :get_shortest_path, graph_id), from: "a", to: "e")
               |> json_response(200)
    end

    test "return false if there's no path", %{conn: conn, graph_id: graph_id} do
      assert %{"data" => false} ==
               conn
               |> post(Routes.api_path(conn, :get_shortest_path, graph_id), from: "a", to: "e")
               |> json_response(200)
    end

    test "returns an error when graph doesn't exists", %{conn: conn} do
      assert "Not Found" =
               conn
               |> post(Routes.api_path(conn, :get_shortest_path, 42), from: "a", to: "e")
               |> json_response(404)
    end
  end
end
