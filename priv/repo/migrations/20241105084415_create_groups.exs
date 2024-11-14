defmodule Champions.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :league_id, references(:leagues, on_delete: :nothing)
      add :owner, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:groups, [:league_id])
    create index(:groups, [:owner])
  end
end
