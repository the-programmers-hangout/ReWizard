defmodule Rewizard.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Cache.Me
  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage

  def start_link do
    :ets.new(:uptime, [:set, :public, :named_table])
    Consumer.start_link(__MODULE__)
  end

  @commands %{
    "find" => Rewizard.Cogs.Find,
    "find_all" => Rewizard.Cogs.FindAll,
    "valid" => Rewizard.Cogs.Valid,
    "split" => Rewizard.Cogs.Split,
    "replace" => Rewizard.Cogs.Replace,
    "help" => Rewizard.Cogs.Help,
    "info" => Rewizard.Cogs.Info
  }

  def handle_event({:READY, _data, _ws}) do
    Enum.each(
      @commands,
      fn {name, cog} ->
        CommandStorage.add_command([name], cog)
      end
    )

    :ets.insert(:uptime, {"uptime", DateTime.utc_now()})
  end

  def handle_event({:MESSAGE_CREATE, %{author: %{bot: true}}, _ws}) do
    :noop
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
    if msg.content == "<@!#{Me.get().id}>" do
      Rewizard.Cogs.Info.command(msg, [])
    else
      CommandInvoker.handle_message(msg, CommandStorage)
    end
  end

  def handle_event(_event) do
    :noop
  end
end
