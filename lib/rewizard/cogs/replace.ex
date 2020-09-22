defmodule Rewizard.Cogs.Replace do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["replace <regex> <string> <replacement>"]

  @impl true
  def description, do: "Replace the input in the target against this regex"

  @impl true
  def predicates, do: [&Rewizard.Predicates.rate_limit/1, &Rewizard.Predicates.correct_channel/1]

  def failed(regex, message) do
    %Embed{}
    |> put_title("Rewizard - Replace")
    |> put_color(0xFF0000)
    |> put_field("Regex", "`#{regex}`")
    |> put_field("Error", message)
  end

  def success(regex, target, replacement, result) do
    %Embed{}
    |> put_title("Rewizard - Replace")
    |> put_color(0x008000)
    |> put_field("Regex", "`#{Regex.source(regex)}`")
    |> put_field("Target", "`#{target}`")
    |> put_field("Replacement", "`#{replacement}`")
    |> put_field("Result", "`#{inspect result}`")
  end

  def replace(regex, string, replacement) do
    success(regex, string, replacement, Regex.replace(regex, string, replacement))
  end

  @impl true
  def command(msg, [regex, string, replacement]) do
    reply = case Regex.compile(regex) do
      {:ok, regex} ->
        replace(regex, string, replacement)
      {:error, {error, location}} ->
        failed(regex, "Failed to parse regex at location #{location} with error #{inspect error}")
    end

    Api.create_message(msg.channel_id, embed: reply)
  end
end
