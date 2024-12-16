defmodule Champions.Football.League do
  defstruct [:id, :name, :country, :logo, :flag, :season, :external_league_id]
  alias Champions.Football.Client

  @spec new(map()) :: __MODULE__
  def new(attrs) do
    # WOuld it make more sense to just return a Map?
    %__MODULE__{
      name: attrs["league"]["name"],
      country: attrs["country"]["name"],
      logo: attrs["league"]["logo"],
      flag: attrs["country"]["flag"],
      season: attrs["league"]["season"],
      external_league_id: attrs["league"]["id"]
    }
  end

  @doc """
  Gets a list of leagues.
  Returns a list of League structs.
  """
  def list_leagues do
    case Client.get_leagues() do
      {:ok, %{"response" => leagues}} ->
        {:ok, Enum.map(leagues, &new/1)}

      error ->
        error
    end
  end
end
