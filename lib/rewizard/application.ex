defmodule Rewizard.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Nosedrum.Storage.ETS,
      Rewizard.Consumer
    ]

    opts = [strategy: :one_for_one, name: Rewizard.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
