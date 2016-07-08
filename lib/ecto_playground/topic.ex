defmodule EctoPlayground.Topic do
  use Ecto.Schema

  schema "topics" do
    field :title, :string
    field :description, :string
    field :slug, :string
    has_many :drips, EctoPlayground.Drip

    timestamps()
  end
end
