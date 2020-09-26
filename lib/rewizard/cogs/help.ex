defmodule Rewizard.Cogs.Help do
  @behaviour Nosedrum.Command

  alias Nosedrum.Storage.ETS, as: CommandStorage

  alias Nostrum.Api
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @impl true
  def usage, do: ["help", "help <command>"]

  @impl true
  def description, do: "Get help on using Rewizard."

  @impl true
  def predicates, do: [&Rewizard.Predicates.rate_limit/1, &Rewizard.Predicates.correct_channel/1]

  def no_such_command(name) do
    %Embed{}
    |> put_title("Rewizard - Help - Not found!")
    |> put_color(0xFF0000)
    |> put_field("Command", name)
  end

  def help(name, command) do
    %Embed{}
    |> put_title("Rewizard - Help")
    |> put_color(0x008000)
    |> put_field("Command", name)
    |> put_field("Description", command.description())
    |> put_field("Usage", Enum.join(command.usage(), ", "))
  end

  def help_all(commands) do
    %Embed{}
    |> put_title("Rewizard - Help")
    |> put_color(0x008000)
    |> put_field("Commands", Enum.join(Map.keys(commands), ", "))
  end

  @impl true
  def command(msg, []) do
    Api.create_message!(msg.channel_id, embed: help_all(CommandStorage.all_commands()))
  end

  @impl true
  def command(msg, [name]) do
    reply = case CommandStorage.lookup_command(name) do
      nil -> no_such_command(name)
      command -> help(name, command)
    end
    Api.create_message!(msg.channel_id, embed: reply)
  end
end
