defmodule Rewizard.Cogs.Help do
  @behaviour Nosedrum.Command

  alias Nosedrum.Storage.ETS, as: CommandStorage

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Rewizard.Embeds

  @impl true
  def usage, do: ["help", "help <command>"]

  @impl true
  def description, do: "Get help on using Rewizard."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def no_such_command(name) do
    Embeds.fail("Help - ")
    |> put_field("Command", name)
  end

  def help(name, command) do
    Embeds.success("Help")
    |> put_field("Command", name)
    |> put_field("Description", command.description())
    |> put_field("Usage", Enum.join(command.usage(), ", "))
  end

  def help_all(commands) do
    Embeds.success("Help")
    |> put_field("Commands", "```properties\n" <> Enum.join(Map.keys(commands), "\n") <> "```")
  end

  @impl true
  def command(msg, []) do
    Api.create_message!(msg.channel_id, embed: help_all(CommandStorage.all_commands()))
  end

  @impl true
  def command(msg, [name]) do
    reply =
      case CommandStorage.lookup_command(name) do
        nil -> no_such_command(name)
        command -> help(name, command)
      end

    Api.create_message!(msg.channel_id, embed: reply)
  end
end
