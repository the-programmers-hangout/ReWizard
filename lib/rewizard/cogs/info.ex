defmodule Rewizard.Cogs.Info do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Nostrum.Struct.User
  alias Rewizard.Embeds

  @contributors ["kibb#4205", "elkell#7131"]

  @repository "[[Github]](https://github.com/the-programmers-hangout/ReWizard)"

  @impl true
  def usage, do: ["info"]

  @impl true
  def description, do: "Get information about Rewizard."

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  # Application.spec returns nil when using constants
  def version,
    do: %{
      rewizard: Application.spec(:rewizard, :vsn),
      elixir: System.version(),
      nostrum: Application.spec(:nostrum, :vsn)
    }

  def uptime do
    secs =
      :ets.lookup(:uptime, "uptime")
      |> (fn [{_, start}] -> DateTime.diff(DateTime.utc_now(), start) end).()

    days = div(secs, 86400)
    rem = secs - days * 86400
    hours = div(rem, 3600)
    rem = rem - hours * 3600
    mins = div(rem, 60)
    secs = rem - mins * 60
    ~s"#{days} days, #{hours} hours, #{mins} minutes, #{secs} seconds"
  end

  def info() do
    me = Nostrum.Cache.Me.get()
    %{rewizard: rw, elixir: ex, nostrum: ns} = version()
    version = ~s"```fix\nVersion: #{rw}\nNostrum: #{ns}\nElixir: #{ex}```"

    Embeds.success(~s"#{me.username}##{me.discriminator}")
    |> put_description("Rewizard is a regex validator and evaluator bot made with Elixir.")
    |> put_field("Prefix", Application.get_env(:nosedrum, :prefix), true)
    |> put_field("Contributors", Enum.join(@contributors, "\n"), true)
    |> put_field("Build Info", version)
    |> put_field("Uptime", uptime(), true)
    |> put_field("Source", @repository)
    |> put_thumbnail(User.avatar_url(me))
  end

  @impl true
  def command(msg, _args) do
    Api.create_message!(msg.channel_id, embed: info())
  end
end
