defmodule EctoPlayground.DripTest do
  use ExUnit.Case, async: true

  alias EctoPlayground.Repo
  alias EctoPlayground.Topic
  alias EctoPlayground.Drip

  describe "for a given topic" do
    setup [:create_topic]

    test "we can create a drip", %{elixir: elixir} do
      drip =
        %Drip{
          identifier: "001.1",
          title: "Introducing Elixir",
          teaser: "Why should you even care about Elixir?",
          slug: "introducing-elixir",
          description: "Some text goes here",
          video: "http://www.elixir-lang.org",
          video_length: 100,
          topic: elixir
        }
        {:ok, inserted_drip} = Repo.insert(drip)
        assert inserted_drip.topic.slug == "elixir"
        assert inserted_drip.id
    end
  end

  defp create_topic(context) do
    elixir =
      %Topic{
        title: "Elixir",
        description: "Awesome fault-tolerant concurrency-oriented language",
        slug: "elixir"
      }
    {:ok, inserted_topic} = Repo.insert(elixir)
    {:ok, elixir: inserted_topic}
  end
end
