defmodule IKnowYou.Core.Supervisor do
  @moduledoc false

  alias IKnowYou.Core.State

  @doc false
  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {DynamicSupervisor, :start_link, [[strategy: :one_for_one, name: __MODULE__]]},
      type: :supervisor
    }
  end

  def new_graph(id), do: DynamicSupervisor.start_child(__MODULE__, {State, graph_id: id})
end
