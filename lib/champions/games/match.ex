defmodule Champions.Games.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :date, :naive_datetime
    field :external_id, :string
    field :home_team, :string
    field :away_team, :string
    field :home_score, :string
    field :away_score, :string
    field :league_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:external_id, :date, :home_team, :away_team, :home_score, :away_score])
    |> validate_required([:external_id, :date, :home_team, :away_team, :home_score, :away_score])
  end
end
