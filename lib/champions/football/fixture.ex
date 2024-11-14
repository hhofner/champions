# lib/champions/football/fixture.ex
defmodule Champions.Football.Fixture do
  @moduledoc """
  Schema/struct for a football fixture
  """
  defstruct [:id, :home_team, :away_team, :date, :status, :score]

  @spec new(map()) :: __MODULE__
  def new(attrs) do
    %__MODULE__{
      id: attrs["fixture"]["id"],
      home_team: attrs["teams"]["home"]["name"],
      away_team: attrs["teams"]["away"]["name"],
      date: attrs["fixture"]["date"],
      status: attrs["fixture"]["status"]["long"],
      score: "#{attrs["goals"]["home"]}-#{attrs["goals"]["away"]}"
    }
  end
end
