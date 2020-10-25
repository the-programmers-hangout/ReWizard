defmodule Rewizard.Cogs.Valid do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["valid <regex>"]

  @impl true
  def description, do: "Check if this regex is valid."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def failed(regex, message) do
    %Embed{}
    |> put_title("Rewizard - Valid")
    |> put_color(0xFF0000)
    |> put_field("Regex", "`#{regex}`")
    |> put_field("Error", message)
  end

  def success(regex) do
    %Embed{}
    |> put_title("Rewizard - Valid")
    |> put_color(0x008000)
    |> put_field("Regex", "`#{Regex.source(regex)}`")
    |> put_field("Valid", "Yes.")
  end

  @impl true
  def command(msg, [regex]) do
    reply =
      case Regex.compile(regex) do
        {:ok, regex} ->
          success(regex)

        {:error, {error, location}} ->
          failed(
            regex,
            "Failed to parse regex at location #{location} with error #{inspect(error)}"
          )
      end

    Api.create_message!(msg.channel_id, embed: reply)
  end
end
