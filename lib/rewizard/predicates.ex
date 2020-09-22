defmodule Rewizard.Predicates do
  @rate_limit Application.get_env(:rewizard, :rate_limit_seconds) * 1000
  @regex_channel Application.get_env(:rewizard, :channel_id)

  def rate_limit(msg) do
    case Hammer.check_rate("regex:#{msg.author.id}", @rate_limit, 1) do
      {:allow, _count} -> :passthrough
      {:deny, _limit} -> {:error, ""}
    end
  end

  def correct_channel(msg) do
    case msg.channel_id == @regex_channel do
      true -> :passthrough
      false -> {:error, ""}
    end
  end
end
