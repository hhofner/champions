defmodule Champions.Repo.Migrations.AddLeagueIdToLeagueTable do
  use Ecto.Migration

  def change do
    alter table(:leagues) do
      add :external_league_id, :integer
    end
  end
end
