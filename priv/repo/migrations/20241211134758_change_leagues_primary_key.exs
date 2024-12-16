defmodule Champions.Repo.Migrations.ChangeLeaguesPrimaryKey do
  use Ecto.Migration

  def change do
    drop constraint("matches", "matches_league_id_fkey")
    drop constraint("groups", "groups_league_id_fkey")

    # Create a temporary table with the new structure
    create table(:leagues_new, primary_key: false) do
      add :external_league_id, :integer, primary_key: true
      add :name, :string
      add :country, :string

      timestamps(type: :utc_datetime)
    end

    # Copy data from the old table to the new one
    execute """
    INSERT INTO leagues_new (external_league_id, name, country, inserted_at, updated_at)
    SELECT external_league_id, name, country, inserted_at, updated_at
    FROM leagues
    """

    # Update foreign keys in related tables to point to external_league_id
    execute """
    UPDATE matches m
    SET league_id = l.external_league_id
    FROM leagues l
    WHERE m.league_id = l.id
    """

    execute """
    UPDATE groups g
    SET league_id = l.external_league_id
    FROM leagues l
    WHERE g.league_id = l.id
    """

    # Drop the old table
    drop table(:leagues)

    # Rename the new table to leagues
    rename table(:leagues_new), to: table(:leagues)

    # Modify the matches table to reference the new primary key
    alter table(:matches) do
      modify :league_id, references(:leagues, column: :external_league_id, type: :integer)
    end

    # Modify the groups table to reference the new primary key
    alter table(:groups) do
      modify :league_id, references(:leagues, column: :external_league_id, type: :integer)
    end
  end
end
