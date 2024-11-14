defmodule Champions.Football.League do
  defstruct [:id, :name, :country, :logo, :flag, :season]

  @spec new(map()) :: __MODULE__
  def new(attrs) do
    %__MODULE__{
      id: attrs["league"]["id"],
      name: attrs["league"]["name"],
      country: attrs["country"]["name"],
      logo: attrs["league"]["logo"],
      flag: attrs["country"]["flag"],
      season: attrs["league"]["season"]
    }
  end
end
