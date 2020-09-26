defmodule Rewizard.Predicates do
  alias Nostrum.Api

  def rate_limit(msg) do
    rate_limit = Application.get_env(:rewizard, :rate_limit_seconds) * 1000
    case Hammer.check_rate("regex:#{msg.author.id}", rate_limit, 1) do
      {:allow, _count} -> :passthrough
      {:deny, _limit} -> 
        Api.create_reaction(msg.channel_id, msg.id, "⏰")
        {:error, ""}
    end
  end

  def correct_channel(msg) do
    regex_channel = Application.get_env(:rewizard, :channel_id)
    case msg.channel_id == regex_channel do
      true -> :passthrough
      false -> {:error, ""}
    end
  end
end
