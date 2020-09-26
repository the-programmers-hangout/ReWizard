defmodule Rewizard.Consumer do
  use Nostrum.Consumer

  alias Nosedrum.Invoker.Split, as: CommandInvoker
  alias Nosedrum.Storage.ETS, as: CommandStorage

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  @commands %{
    "find" => Rewizard.Cogs.Find,
    "find_all" => Rewizard.Cogs.FindAll,
    "valid" => Rewizard.Cogs.Valid,
    "split" => Rewizard.Cogs.Split,
    "replace" => Rewizard.Cogs.Replace,
    "help" => Rewizard.Cogs.Help,
  }

  def handle_event({:READY, _data, _ws}) do
    Enum.each(
      @commands,
      fn {name, cog} ->
        CommandStorage.add_command([name], cog)
      end
    )
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws}) do
    CommandInvoker.handle_message(msg, CommandStorage)
  end

  def handle_event(_event) do
    :noop
  end
end
