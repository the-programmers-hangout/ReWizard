defmodule Rewizard.Cogs.Split do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["split <regex> <target>"]

  @impl true
  def description, do: "Split the target with this regex."

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
    |> put_field("Result", "`#{inspect(result)}`")
  end

  def split(regex, target) do
    case Regex.split(regex, target) do
      [] -> failed(regex, "Split resulted in an empty list")
      result -> success(regex, target, result)
    end
  end

  @impl true
  def command(msg, [regex, target]) do
    reply =
      case Regex.compile(regex) do
        {:ok, regex} ->
          split(regex, target)

        {:error, {error, location}} ->
          failed(
            regex,
            "Failed to parse regex at location #{location} with error #{inspect(error)}"
          )
      end

    Api.create_message!(msg.channel_id, embed: reply)
  end
end
