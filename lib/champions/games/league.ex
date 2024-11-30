defmodule Champions.Games.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :name, :string
    field :country, :string
    field :external_league_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :country, :external_league_id])
    |> validate_required([:name, :country, :external_league_id])
  end
end
