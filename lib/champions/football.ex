# lib/football.ex
defmodule Champions.Football do
  @moduledoc """
  The Football context - this is the public API for football-related operations
  """
  alias Champions.Football.{Client, Fixture, League}

  @doc """
  Gets fixtures for a specific league and season.
  Returns a list of Fixture structs.
  """
  def list_fixtures(league_id, season) do
    case Client.get_fixtures(league_id, season) do
      {:ok, %{"response" => fixtures}} ->
        {:ok, Enum.map(fixtures, &Fixture.new/1)}

      {:error, _} = error ->
        error
    end
  end

  @doc """
  Gets a list of leagues.
  Returns a list of League structs.
  """
  def list_leagues do
    case Client.get_leagues() do
      {:ok, %{"response" => leagues}} ->
        {:ok, Enum.map(leagues, &League.new/1)}

      error ->
        error
    end
  end

  @doc """
  Gets standings for a specific league and season.
  """
  def get_standings(league_id, season) do
    case Client.get_standings(league_id, season) do
      {:ok, %{"response" => [%{"league" => %{"standings" => standings}}]}} ->
        {:ok, standings}

      {:error, _} = error ->
        error
    end
  end

  # Add more context functions as needed
end
