# lib/champions/football/fixture.ex
defmodule Champions.Football.Fixture do
  @moduledoc """
  Schema/struct for a football fixture
  """
  defstruct [:id, :home_team, :away_team, :home_score, :away_score, :date, :status, :score]

  @spec new(map()) :: __MODULE__
  def new(attrs) do
    %__MODULE__{
      date: attrs["fixture"]["date"],
      id: attrs["fixture"]["id"],
      home_team: attrs["teams"]["home"]["name"],
      away_team: attrs["teams"]["away"]["name"],
      home_score: attrs["score"]["fulltime"]["home"],
      away_score: attrs["score"]["fulltime"]["away"],
      status: attrs["fixture"]["status"]["long"]
    }
  end
end
