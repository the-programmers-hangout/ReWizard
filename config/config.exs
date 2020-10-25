import Config

config :logger, level: :info

config :mnesia,
  dir: '.mnesia/#{Mix.env()}/#{node()}'

config :nosedrum,
  prefix: "re!"

config :nostrum,
  num_shards: :auto

config :hammer,
  backend: {
    Hammer.Backend.ETS,
    [
      expiry_ms: 60_000 * 60 * 4,
      cleanup_interval_ms: 60_000 * 10
    ]
  }
