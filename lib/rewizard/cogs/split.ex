defmodule Rewizard.Cogs.Split do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Rewizard.Embeds

  @impl true
  def usage, do: ["split <regex> <target>", "split <regex> <flags> <target>"]

  @impl true
  def description, do: "Split the target with this regex."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def success(regex, target, result) do
    Embeds.success("Split")
    |> Embeds.regex(regex)
    |> put_field("Target", "`#{target}`")
    |> put_field("Result", "`#{inspect(result)}`")
  end

  def failed(regex, message) do
    Embeds.fail("Split")
    |> Embeds.regex(regex)
    |> put_field("Error", message)
  end

  def split(str_regex, flags, target) do
    res =
      with {:ok, regex} <- Rewizard.Regex.compile(str_regex, flags),
           {:ok, result} <- Rewizard.Regex.split(regex, target),
           do: success(regex, target, result)

    case res do
      {:error, str_regex, msg} ->
        failed(str_regex, msg)

      {:fail, regex, msg} ->
        failed(regex, msg)

      _ ->
        res
    end
  end

  @impl true
  def command(msg, [regex, target]) do
    reply = split(regex, "", target)
    Api.create_message!(msg.channel_id, embed: reply)
  end

  @impl true
  def command(msg, [regex, flags, target]) do
    reply = split(regex, flags, target)
    Api.create_message!(msg.channel_id, embed: reply)
  end
end
