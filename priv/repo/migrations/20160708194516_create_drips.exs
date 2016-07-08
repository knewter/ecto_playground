defmodule EctoPlayground.Repo.Migrations.CreateDrips do
  use Ecto.Migration

  def change do
    create table(:drips) do
      add :identifier, :string
      add :title, :string
      add :teaser, :string
      add :slug, :string
      add :description, :text
      add :video, :string
      add :video_length, :integer
      add :topic_id, references(:topics)

      timestamps()
    end
  end
end
