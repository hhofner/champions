defmodule Champions.GamesTest do
  use Champions.DataCase

  alias Champions.Games

  describe "matches" do
    alias Champions.Games.Match

    import Champions.GamesFixtures

    @invalid_attrs %{date: nil, external_id: nil, home_team: nil, away_team: nil, home_score: nil, away_score: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Games.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Games.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{date: ~N[2024-11-04 08:38:00], external_id: "some external_id", home_team: "some home_team", away_team: "some away_team", home_score: "some home_score", away_score: "some away_score"}

      assert {:ok, %Match{} = match} = Games.create_match(valid_attrs)
      assert match.date == ~N[2024-11-04 08:38:00]
      assert match.external_id == "some external_id"
      assert match.home_team == "some home_team"
      assert match.away_team == "some away_team"
      assert match.home_score == "some home_score"
      assert match.away_score == "some away_score"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      update_attrs = %{date: ~N[2024-11-05 08:38:00], external_id: "some updated external_id", home_team: "some updated home_team", away_team: "some updated away_team", home_score: "some updated home_score", away_score: "some updated away_score"}

      assert {:ok, %Match{} = match} = Games.update_match(match, update_attrs)
      assert match.date == ~N[2024-11-05 08:38:00]
      assert match.external_id == "some updated external_id"
      assert match.home_team == "some updated home_team"
      assert match.away_team == "some updated away_team"
      assert match.home_score == "some updated home_score"
      assert match.away_score == "some updated away_score"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_match(match, @invalid_attrs)
      assert match == Games.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Games.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Games.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Games.change_match(match)
    end
  end

  describe "leagues" do
    alias Champions.Games.League

    import Champions.GamesFixtures

    @invalid_attrs %{name: nil, country: nil}

    test "list_leagues/0 returns all leagues" do
      league = league_fixture()
      assert Games.list_leagues() == [league]
    end

    test "get_league!/1 returns the league with given id" do
      league = league_fixture()
      assert Games.get_league!(league.id) == league
    end

    test "create_league/1 with valid data creates a league" do
      valid_attrs = %{name: "some name", country: "some country"}

      assert {:ok, %League{} = league} = Games.create_league(valid_attrs)
      assert league.name == "some name"
      assert league.country == "some country"
    end

    test "create_league/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_league(@invalid_attrs)
    end

    test "update_league/2 with valid data updates the league" do
      league = league_fixture()
      update_attrs = %{name: "some updated name", country: "some updated country"}

      assert {:ok, %League{} = league} = Games.update_league(league, update_attrs)
      assert league.name == "some updated name"
      assert league.country == "some updated country"
    end

    test "update_league/2 with invalid data returns error changeset" do
      league = league_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_league(league, @invalid_attrs)
      assert league == Games.get_league!(league.id)
    end

    test "delete_league/1 deletes the league" do
      league = league_fixture()
      assert {:ok, %League{}} = Games.delete_league(league)
      assert_raise Ecto.NoResultsError, fn -> Games.get_league!(league.id) end
    end

    test "change_league/1 returns a league changeset" do
      league = league_fixture()
      assert %Ecto.Changeset{} = Games.change_league(league)
    end
  end

  describe "matches" do
    alias Champions.Games.Match

    import Champions.GamesFixtures

    @invalid_attrs %{date: nil, external_id: nil, home_team: nil, away_team: nil, home_score: nil, away_score: nil}

    test "list_matches/0 returns all matches" do
      match = match_fixture()
      assert Games.list_matches() == [match]
    end

    test "get_match!/1 returns the match with given id" do
      match = match_fixture()
      assert Games.get_match!(match.id) == match
    end

    test "create_match/1 with valid data creates a match" do
      valid_attrs = %{date: ~N[2024-11-04 08:45:00], external_id: "some external_id", home_team: "some home_team", away_team: "some away_team", home_score: "some home_score", away_score: "some away_score"}

      assert {:ok, %Match{} = match} = Games.create_match(valid_attrs)
      assert match.date == ~N[2024-11-04 08:45:00]
      assert match.external_id == "some external_id"
      assert match.home_team == "some home_team"
      assert match.away_team == "some away_team"
      assert match.home_score == "some home_score"
      assert match.away_score == "some away_score"
    end

    test "create_match/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_match(@invalid_attrs)
    end

    test "update_match/2 with valid data updates the match" do
      match = match_fixture()
      update_attrs = %{date: ~N[2024-11-05 08:45:00], external_id: "some updated external_id", home_team: "some updated home_team", away_team: "some updated away_team", home_score: "some updated home_score", away_score: "some updated away_score"}

      assert {:ok, %Match{} = match} = Games.update_match(match, update_attrs)
      assert match.date == ~N[2024-11-05 08:45:00]
      assert match.external_id == "some updated external_id"
      assert match.home_team == "some updated home_team"
      assert match.away_team == "some updated away_team"
      assert match.home_score == "some updated home_score"
      assert match.away_score == "some updated away_score"
    end

    test "update_match/2 with invalid data returns error changeset" do
      match = match_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_match(match, @invalid_attrs)
      assert match == Games.get_match!(match.id)
    end

    test "delete_match/1 deletes the match" do
      match = match_fixture()
      assert {:ok, %Match{}} = Games.delete_match(match)
      assert_raise Ecto.NoResultsError, fn -> Games.get_match!(match.id) end
    end

    test "change_match/1 returns a match changeset" do
      match = match_fixture()
      assert %Ecto.Changeset{} = Games.change_match(match)
    end
  end
end
