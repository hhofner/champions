defmodule Champions.Games.League do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:external_league_id, :integer, []}
  schema "leagues" do
    field :name, :string
    field :country, :string

    has_many :matches, Champions.Games.Match,
      foreign_key: :league_id,
      references: :external_league_id

    has_many :groups, Champions.Groups.Group,
      foreign_key: :league_id,
      references: :external_league_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :country, :external_league_id])
    |> validate_required([:name, :country, :external_league_id])
  end
end
