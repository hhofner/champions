defmodule Champions.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Champions.Repo

  alias Champions.Games.Match
  alias Champions.Games.League

  @doc """
  Returns the list of matches.

  ## Examples

      iex> list_matches()
      [%Match{}, ...]

  """

  def list_matches_current(league_id, season) do
    query = from(m in Match, where: m.league_id == ^league_id and m.season == ^season)

    case Repo.all(query) do
      [] ->
        with {:ok, fixtures} <- Champions.Football.Fixture.list_fixtures(league_id, season) do
          fixtures
          |> Enum.map(fn fixture ->
            %{
              date: fixture.date,
              home_team: fixture.home_team,
              away_team: fixture.away_team,
              home_score: "-",
              away_score: "-",
              status: fixture.status,
              season: season,
              league_id: league_id,
              # Convert ID to string if needed
              external_id: to_string(fixture.id)
            }
          end)
          |> Enum.map(&Match.changeset(%Match{}, &1))
          |> Enum.each(&Repo.insert!/1)

          {:ok, Repo.all(query)}
        else
          {:error, _} = error -> {:error, error}
        end

      matches ->
        {:ok, matches}
    end
  end

  @doc """
  Returns list of current day matches.
  """
  def list_current_day_matches do
    Repo.all(from m in Match, where: m.date == ^Date.utc_today())
  end

  @doc """
  Gets a single match.

  Raises `Ecto.NoResultsError` if the Match does not exist.

  ## Examples

      iex> get_match!(123)
      %Match{}

      iex> get_match!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match!(id), do: Repo.get!(Match, id)

  @doc """
  Creates a match.

  ## Examples

      iex> create_match(%{field: value})
      {:ok, %Match{}}

      iex> create_match(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match.

  ## Examples

      iex> update_match(match, %{field: new_value})
      {:ok, %Match{}}

      iex> update_match(match, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match(%Match{} = match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match.

  ## Examples

      iex> delete_match(match)
      {:ok, %Match{}}

      iex> delete_match(match)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match(%Match{} = match) do
    Repo.delete(match)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match changes.

  ## Examples

      iex> change_match(match)
      %Ecto.Changeset{data: %Match{}}

  """
  def change_match(%Match{} = match, attrs \\ %{}) do
    Match.changeset(match, attrs)
  end

  alias Champions.Games.League

  @doc """
  Returns the list of leagues.

  ## Examples

      iex> list_leagues()
      [%League{}, ...]

  """
  def list_leagues do
    leagues = Repo.all(League)

    if leagues == [] do
      {:ok, leagues} = Champions.Football.League.list_leagues()

      leagues
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&League.changeset(%League{}, &1))
      |> Enum.each(&Repo.insert!/1)
    end

    query = from(l in League, limit: 10)
    Repo.all(query)
  end

  @doc """
  Gets a single league.

  Raises `Ecto.NoResultsError` if the League does not exist.

  ## Examples

      iex> get_league!(123)
      %League{}

      iex> get_league!(456)
      ** (Ecto.NoResultsError)

  """
  def get_league!(id), do: Repo.get!(League, id)

  @doc """
  Creates a league.

  ## Examples

      iex> create_league(%{field: value})
      {:ok, %League{}}

      iex> create_league(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_league(attrs \\ %{}) do
    %League{}
    |> League.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %League{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a league.

  ## Examples

      iex> delete_league(league)
      {:ok, %League{}}

      iex> delete_league(league)
      {:error, %Ecto.Changeset{}}

  """
  def delete_league(%League{} = league) do
    Repo.delete(league)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking league changes.

  ## Examples

      iex> change_league(league)
      %Ecto.Changeset{data: %League{}}

  """
  def change_league(%League{} = league, attrs \\ %{}) do
    League.changeset(league, attrs)
  end

  @doc """
  """
  def update_leagues() do
    with {:ok, leagues} <- Champions.Football.League.list_leagues() do
      leagues
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Champions.Games.League.changeset(%League{}, &1))
      |> Enum.each(&Repo.insert!/1)
    end
  end
end
