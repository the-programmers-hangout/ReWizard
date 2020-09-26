import Config

config :nostrum,
  token: System.fetch_env!("REWIZARD_TOKEN"),
  num_shards: :auto

config :rewizard,
  channel_id: System.fetch_env!("REWIZARD_CHANNEL") 
    |> String.to_integer,
  rate_limit_seconds: System.fetch_env!("REWIZARD_RATE_LIMIT") 
    |> String.to_integer

