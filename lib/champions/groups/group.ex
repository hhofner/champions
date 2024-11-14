defmodule Champions.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    field :league_id, :id
    field :owner, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :league_id, :owner])
    |> validate_required([:name, :league_id, :owner])
  end
end
