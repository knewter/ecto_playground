defmodule EctoPlayground.DripTest do
  use ExUnit.Case, async: true

  alias EctoPlayground.Repo
  alias EctoPlayground.Topic
  alias EctoPlayground.Drip
  import Ecto.Query

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

  describe "with a drip" do
    setup [:create_topic, :create_drip]

    test "we can find it by slug", %{elixir: elixir, drip: drip} do
      where = [slug: drip.slug]

      query =
        from d in Drip,
          where: ^where

      found_drip = Repo.one(query)

      assert found_drip.id == drip.id
    end

    test "we can use map update", %{elixir: elixir, drip: drip} do
      where = [slug: drip.slug]

      query =
        from d in Drip,
          where: ^where,
          select: %{d | title: "giggity"}

      found_drip = Repo.one(query)

      assert "giggity" = found_drip.title
    end
  end

  describe "with quite a few drips" do
    setup [:import_topics, :import_drips]

    test "we can get the total length of videos for a given topic", %{elixir: elixir} do
      elixir_drips_query =
        from d in Drip,
          where: [topic_id: ^elixir.id]

      drip_length = Repo.aggregate(elixir_drips_query, :sum, :video_length)

      IO.inspect drip_length
      assert drip_length > 0
    end

    test "using expressions in select maps" do
      drips_query =
        from d in Drip,
          select: %{ d.slug => d.video_length}

      drip_lengths = Repo.all(drips_query)

      IO.inspect drip_lengths
      assert true
    end
  end

  defp create_topic(_context) do
    elixir =
      %Topic{
        title: "Elixir",
        description: "Awesome fault-tolerant concurrency-oriented language",
        slug: "elixir"
      }
    {:ok, inserted_topic} = Repo.insert(elixir)
    {:ok, elixir: inserted_topic}
  end

  defp create_drip(context) do
    drip =
      %Drip{
        identifier: "001",
        title: "Introducing Elixir",
        teaser: "Why should you even care about Elixir?",
        slug: "introducing-elixir",
        description: "Some text goes here",
        video: "http://www.elixir-lang.org",
        video_length: 100,
        topic: context.elixir
      }
    {:ok, inserted_drip} = Repo.insert(drip)
    {:ok, drip: inserted_drip}
  end

  defp import_topics(_context) do
    Path.expand("../topics_export.csv", __DIR__)
    |> File.stream!
    |> Stream.drop(1)
    |> CSV.decode(headers: [:id, :title, :description, :slug, :created_at, :updated_at])
    |> Enum.each(fn(row) ->
      {id, ""} = Integer.parse(row.id)
      %Topic{
        id: id,
        title: row.title,
        description: row.description,
        slug: row.slug
      } |> Repo.insert!
    end)
    elixir = Repo.one(from t in Topic, where: [slug: "elixir"])
    {:ok, elixir: elixir}
  end

  defp import_drips(context) do
    Path.expand("../drips_export.csv", __DIR__)
    |> File.stream!
    |> Stream.drop(1)
    |> CSV.decode(headers: [:id, :identifier, :title, :description, :screenshot, :teaser, :slug, :free, :video_length, :published_at, :created_at, :updated_at, :deprecated])
    |> Enum.each(fn(row) ->
      {id, ""} = Integer.parse(row.id)
      {video_length, ""} = Integer.parse(row.video_length)
      topic_id =
        if String.match?(row.identifier, ~r/\./) do
          nil
        else
          context.elixir.id
        end
      %Drip{
        id: id,
        identifier: row.identifier,
        title: row.title,
        teaser: row.teaser,
        slug: row.slug,
        description: row.description,
        video_length: video_length,
        topic_id: topic_id
      } |> Repo.insert!
    end)
  end
end
