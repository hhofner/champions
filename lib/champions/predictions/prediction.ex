defmodule Champions.Predictions.Prediction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "predictions" do
    field :predicted_home_score, :integer
    field :predicted_away_score, :integer
    field :user_id, :id
    belongs_to :match, Champions.Games.Match

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prediction, attrs) do
    prediction
    |> cast(attrs, [:predicted_home_score, :predicted_away_score])
    |> validate_required([:predicted_home_score, :predicted_away_score])
  end
end
