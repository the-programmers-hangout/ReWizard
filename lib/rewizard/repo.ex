defmodule Rewizard.Repo do
  use Ecto.Repo,
    otp_app: :rewizard,
    adapter: Ecto.Adapters.Mnesia
end
