defmodule EctoPlaygroundTest do
  use ExUnit.Case, async: true

  alias EctoPlayground.Repo
  alias EctoPlayground.Topic

  test "creating topics" do
    topic =
      %Topic{
        title: "Elixir",
        description: "Awesome fault-tolerant concurrency-oriented language",
        slug: "elixir"
      }
    {:ok, inserted_topic} = Repo.insert(topic)
    assert inserted_topic.id
  end
end
