defmodule EctoPlayground do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(EctoPlayground.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: EctoPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
