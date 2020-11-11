defmodule IKnowYou.Core.Registry do
  @moduledoc false

  @doc false
  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {Registry, :start_link, [[keys: :unique, name: __MODULE__]]},
      type: :supervisor
    }
  end

  def get_graph_pid(digraph_id) do
    case Registry.lookup(__MODULE__, digraph_id) do
      [] -> {:error, :graph_not_found}
      [{pid, _}] -> {:ok, pid}
    end
  end

  def name(digraph_id), do: {:via, Registry, {__MODULE__, digraph_id}}
end
