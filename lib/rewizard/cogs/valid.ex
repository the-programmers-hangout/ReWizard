defmodule Rewizard.Cogs.Valid do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["valid <regex>", "valid <regex> <flags>"]

  @impl true
  def description, do: "Check if this regex is valid."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def success(regex) do
    %Embed{}
    |> put_title("Rewizard - Valid")
    |> put_color(0x008000)
    |> put_field("Regex", Rewizard.Regex.source(regex))
    |> put_field("Valid", "Yes.")
  end

  def failed(strRegex, message) do
    %Embed{}
    |> put_title("Rewizard - Valid")
    |> put_color(0xFF0000)
    |> put_field("Regex", strRegex)
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
