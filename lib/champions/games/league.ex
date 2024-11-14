defmodule Champions.Games.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :name, :string
    field :country, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :country])
    |> validate_required([:name, :country])
  end
end
