defmodule EctoPlayground.Drip do
  use Ecto.Schema

  schema "drips" do
    field :identifier, :string
    field :title, :string
    field :teaser, :string
    field :slug, :string
    field :description, :string
    field :video, :string
    field :video_length, :integer
    belongs_to :topic, EctoPlayground.Topic

    timestamps()
  end
end
