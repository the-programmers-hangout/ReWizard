defmodule Rewizard.Embeds do
  alias Nostrum.Struct.Embed
  import Nostrum.Struct.Embed

  @color_fail 0xFF0000

  @color_success 0x008000

  def success(title) do
    %Embed{}
    |> put_title("Rewizard - #{title}")
    |> put_color(@color_success)
  end

  def fail(title) do
    %Embed{}
    |> put_title("Rewizard - #{title}")
    |> put_color(@color_fail)
  end

  def regex(embed, {strRegex, nil}) do
    embed
      |> put_field("Regex", strRegex)
  end

  def regex(embed, {strRegex, flags}) do
    embed
      |> put_field("Regex", strRegex)
      |> put_field("Flags", flags)
  end

  def regex(embed, regex) do
    regex(embed, Rewizard.Regex.source(regex))
  end
end
