defmodule Champions.Repo.Migrations.AddSeasonToMatchesTable do
  use Ecto.Migration

  def change do
    alter table(  :matches) do
      add :season, :integer
    end
  end
end
