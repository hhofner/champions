defmodule Champions.Repo.Migrations.CreatePredictions do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :predicted_home_score, :integer
      add :predicted_away_score, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :match_id, references(:matches, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:predictions, [:user_id])
    create index(:predictions, [:match_id])
  end
end
