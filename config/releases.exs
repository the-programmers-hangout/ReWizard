import Config

config :nostrum,
  token: System.fetch_env!("REWIZARD_TOKEN"),
  num_shards: :auto

config :rewizard,
  allowed_channels:
    System.fetch_env!("REWIZARD_CHANNEL")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1),
  rate_limit_seconds:
    System.fetch_env!("REWIZARD_RATE_LIMIT")
    |> String.to_integer()
