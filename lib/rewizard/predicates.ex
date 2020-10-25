defmodule Rewizard.Predicates do
  alias Nostrum.Api

  def rate_limit(msg) do
    rate_limit = Application.get_env(:rewizard, :rate_limit_seconds) * 1000

    case Hammer.check_rate("regex:#{msg.author.id}", rate_limit, 1) do
      {:allow, _count} ->
        :passthrough

      {:deny, _limit} ->
        Api.create_reaction(msg.channel_id, msg.id, "⏰")
        {:error, ""}
    end
  end

  def correct_channel(msg) do
    allowed_channels = Application.get_env(:rewizard, :allowed_channels)

    if msg.channel_id in allowed_channels do
      :passthrough
    else
      {:error, ""}
    end
  end
end
