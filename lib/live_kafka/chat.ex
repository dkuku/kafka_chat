defmodule LiveKafka.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:value, :topic]
  @attributes @required ++ [:user]

  embedded_schema do
    field :value, :string
    field :topic, :string
    field :user, :string
  end

  @spec form :: Ecto.Changeset.t()
  def form, do: cast(%__MODULE__{}, %{}, @attributes)
end
