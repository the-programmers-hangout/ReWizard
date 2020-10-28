defmodule Rewizard.Regex do
  def source(regex) do
    source(regex.source, Regex.opts(regex))
  end

  def source(str_regex, flags) do
    if flags == "" do
      {"`/#{str_regex}/`", nil}
    else
      {"`/#{str_regex}/`", "`-#{flags}`"}
    end
  end

  def compile(regex, flags) do
    case Regex.compile(regex, flags) do
      {:ok, regex} ->
        {:ok, regex}

      {:error, {:invalid_option, flag}} ->
        {:error, source(regex, flag), "Invalid flag provided: #{flag}"}

      {:error, {error, location}} ->
        {:error, source(regex, flags),
         "Failed to parse regex at location #{location} with error #{inspect(error)}"}
    end
  end

  def find(regex, target, captures) do
    case Regex.run(regex, target, captures) do
      nil -> {:fail, regex, "Didn't find anything"}
      result -> {:ok, result}
    end
  end

  def split(regex, target) do
    case Regex.split(regex, target) do
      [] -> {:fail, regex, "Split resulted in an empty list"}
      result -> {:ok, result}
    end
  end
end
