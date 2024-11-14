defmodule Champions.PredictionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Champions.Predictions` context.
  """

  @doc """
  Generate a prediction.
  """
  def prediction_fixture(attrs \\ %{}) do
    {:ok, prediction} =
      attrs
      |> Enum.into(%{
        predicted_away_score: 42,
        predicted_home_score: 42
      })
      |> Champions.Predictions.create_prediction()

    prediction
  end
end
