defmodule Rewizard.Cogs.Find do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["find <regex> <target>"]

  @impl true
  def description, do: "Find this regex in that target."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def failed(regex, message) do
    %Embed{}
    |> put_title("Rewizard - Find")
    |> put_color(0xFF0000)
    |> put_field("Regex", "`#{regex}`")
    |> put_field("Error", message)
  end

  def success(regex, target, result) do
    %Embed{}
    |> put_title("Rewizard - Find")
    |> put_color(0x008000)
    |> put_field("Regex", "`#{Regex.source(regex)}`")
    |> put_field("Target", "`#{target}`")
    |> put_field("Result", "`#{inspect result}`")
  end

  def find(regex, target) do
    case Regex.run(regex, target, capture: :first) do
      nil -> failed(regex, "Didn't find anything.")
      result -> success(regex, target, result)
    end
  end

  @impl true
  def command(msg, [regex, target]) do
    reply = case Regex.compile(regex) do
      {:ok, regex} ->
        find(regex, target)
      {:error, {error, location}} ->
        failed(regex, "Failed to parse regex at location #{location} with error #{inspect error}")
    end

    Api.create_message!(msg.channel_id, embed: reply)
  end
end
