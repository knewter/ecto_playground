defmodule EctoPlayground.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_playground,
     version: "0.1.0",
     elixir: "~> 1.4-dev",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  def application do
    [applications: [:postgrex, :ecto, :logger],
     mod: {EctoPlayground, []}]
  end

  defp deps do
    [
      {:postgrex, "~> 0.11.2"},
      {:ecto, "~> 2.0"},
      {:csv, "~> 1.4.2"}
    ]
  end

  defp aliases do
    [
      "test": ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
