defmodule Champions.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Champions.Games` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        away_score: "some away_score",
        away_team: "some away_team",
        date: ~N[2024-11-04 08:38:00],
        external_id: "some external_id",
        home_score: "some home_score",
        home_team: "some home_team"
      })
      |> Champions.Games.create_match()

    match
  end

  @doc """
  Generate a league.
  """
  def league_fixture(attrs \\ %{}) do
    {:ok, league} =
      attrs
      |> Enum.into(%{
        country: "some country",
        name: "some name"
      })
      |> Champions.Games.create_league()

    league
  end

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        away_score: "some away_score",
        away_team: "some away_team",
        date: ~N[2024-11-04 08:45:00],
        external_id: "some external_id",
        home_score: "some home_score",
        home_team: "some home_team"
      })
      |> Champions.Games.create_match()

    match
  end
end
