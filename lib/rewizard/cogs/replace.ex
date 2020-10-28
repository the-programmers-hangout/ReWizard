defmodule Rewizard.Cogs.Replace do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Rewizard.Embeds

  @impl true
  def usage,
    do: [
      "replace <regex> <source> <replacement>",
      "replace <regex> <flags> <source> <replacement>"
    ]

  @impl true
  def description, do: "Replace the input in the target against this regex"

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def success(regex, target, replacement, result) do
    Embeds.success("Replace")
    |> Embeds.regex(regex)
    |> put_field("Target", "`#{target}`")
    |> put_field("Replacement", "`#{replacement}`")
    |> put_field("Result", "`#{inspect(result)}`")
  end

  def failed(tpl_regex, message) do
    Embeds.fail("Replace")
    |> Embeds.regex(tpl_regex)
    |> put_field("Error", message)
  end

  def replace(str_regex, flags, source, replacement) do
    case Rewizard.Regex.compile(str_regex, flags) do
      {:ok, regex} ->
        success(regex, source, replacement, Regex.replace(regex, source, replacement))

      {:error, str_regex, msg} ->
        failed(str_regex, msg)
    end
  end

  @impl true
  def command(msg, [str_regex, source, replacement]) do
    reply = replace(str_regex, "", source, replacement)
    Api.create_message!(msg.channel_id, embed: reply)
  end

  @impl true
  def command(msg, [str_regex, flags, source, replacement]) do
    reply = replace(str_regex, flags, source, replacement)
    Api.create_message!(msg.channel_id, embed: reply)
  end
end
