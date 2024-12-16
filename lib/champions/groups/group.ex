defmodule Champions.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string

    belongs_to :league, Champions.Games.League,
      foreign_key: :league_id,
      references: :external_league_id,
      type: :integer

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
