defmodule Champions.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :external_id, :string
      add :date, :naive_datetime
      add :home_team, :string
      add :away_team, :string
      add :home_score, :string
      add :away_score, :string
      add :league_id, references(:leagues, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:league_id])
  end
end
