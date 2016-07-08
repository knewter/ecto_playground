use Mix.Config

# We have to specify our list of repos in configuration
config :ecto_playground, ecto_repos: [EctoPlayground.Repo]

# And we'll configure our repo.  My user has superuser access on postgres, so I
# don't need to provide a username or password.
config :ecto_playground, EctoPlayground.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "ecto_playground"
