defmodule IKnowYou.Core.Validator do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: binary(),
          friends: [%{required(:name) => binary()}]
        }

  @required ~w(name)a
  embedded_schema do
    field :name, :string

    embeds_many :friends, Friend, on_replace: :delete do
      field :name, :string
    end
  end

  def run(params) do
    params
    |> changeset()
    |> apply_changeset()
  end

  @doc false
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required)
    |> cast_embed(:friends, with: &friend_changeset/2)
    |> validate_required(@required)
  end

  defp friend_changeset(friend, params) do
    friend
    |> cast(params, @required)
    |> validate_required(@required)
  end

  defp apply_changeset(%Ecto.Changeset{valid?: true} = cs), do: {:ok, apply_changes(cs)}
  defp apply_changeset(changeset), do: {:error, changeset}
end
