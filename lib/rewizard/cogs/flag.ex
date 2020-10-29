defmodule Rewizard.Cogs.Flag do
  @behaviour Nosedrum.Command

  alias Nostrum.Api
  import Nostrum.Struct.Embed
  alias Rewizard.Embeds

  @doc """
  key => {modifier, description, example usage, example output}
  """
  @flags %{
    "u" =>
      {"(u)nicode",
       "Enables Unicode specific patterns like `\\p`. Causes character classes like `\\w`, `\\W`, `\\s`, etc. to match on Unicode.",
       "`re!find \[[:lower:]]+ u niché`", "`[\"niché\"]`"},
    "i" =>
      {"caseless (i)", "adds case insensitivity", "`re!find hello i HELLO`", "`[\"HELLO\"]`"},
    "s" =>
      {"dotall (s)", "causes dot to match newlines", "`re!find ... s \"a\nb\"`", "`[\"a\\nb\"]`"},
    "m" =>
      {"(m)ultiline",
       "causes ^ and $ to mark the beginning and end of each line. Use '\\A' and '\\Z' to match beginning and end of the string.",
       "`re!find ^hello m \"hi\nhello\"`", "`[\"hello\"]`"},
    "x" =>
      {"e(x)tended",
       "whitespace characters are ignored except when in character sets. allow # to delimit comments.",
       "`re!find \"w as #this is a comment\" x \"was\"`", "`[\"was\"]`"},
    "f" =>
      {"(f)irstline", "forces an unanchored pattern to match before or at the first newline",
       "`re!find abc f \"a\nabc\"`", "No match"},
    "U" =>
      {"(U)ngreedy", "inverts the 'greediness' of the regexp", "`re!find hel.*o U hellllooooo`",
       "[\"hellllo\"]"}
  }

  @impl true
  def usage,
    do: ["flag", "flag <flag>"]

  @impl true
  def description, do: "Explain and see examples of the different available flags for Rewizard"

  @impl true
  def predicates, do: [&Rewizard.Predicates.correct_channel/1, &Rewizard.Predicates.rate_limit/1]

  def overview do
    values =
      Map.values(@flags)
      |> Enum.map(fn {mod, _desc, _inp, _res} -> mod end)

    Embeds.success("Flag")
    |> put_description("Use re!flag [char] for more info and examples.")
    |> put_field("Available Flags", Enum.join(values, ", "))
  end

  def no_flag(key) do
    Embeds.fail("Flag - Not Found!")
    |> put_field("Key", key)
  end

  def flag({mod, desc, inp, res}) do
    Embeds.success("Flag - #{mod}")
    |> put_description(desc)
    |> put_field("Example Input", inp)
    |> put_field("Result", res)
  end

  @impl true
  def command(msg, []) do
    Api.create_message!(msg.channel_id, embed: overview())
  end

  @impl true
  def command(msg, [key]) do
    reply =
      case Map.get(@flags, key) do
        nil -> no_flag(key)
        data -> flag(data)
      end

    Api.create_message!(msg.channel_id, embed: reply)
  end
end
