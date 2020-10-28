defmodule Rewizard.Cogs.Valid do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Rewizard.Embeds

  @impl true
  def usage, do: ["valid <regex>", "valid <regex> <flags>"]

  @impl true
  def description, do: "Check if this regex is valid."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def success(regex) do
    Embeds.success("Valid")
      |> Embeds.regex(regex)
      |> put_field("Valid", "Yes.")
  end

  def failed(tpl_regex, message) do
    Embeds.fail("Valid")
      |> Embeds.regex(tpl_regex)
      |> put_field("Error", message)
  end

  def valid(strRegex, flags) do
    case Rewizard.Regex.compile(strRegex, flags) do
      {:ok, regex} ->
        success(regex)

      {:error, strRegex, msg} ->
        failed(strRegex, msg)
    end
  end

  @impl true
  def command(msg, [regex]) do
    reply = valid(regex, "")
    Api.create_message!(msg.channel_id, embed: reply)
  end

  @impl true
  def command(msg, [regex, flags]) do
    reply = valid(regex, flags)
    Api.create_message!(msg.channel_id, embed: reply)
  end
end
