import Config

config :logger, level: :info

config :rewizard,
       #channel_id: 754787306090659850,
       channel_id: 757866846673174591,
       rate_limit_seconds: 30

config :mnesia,
       dir: '.mnesia/#{Mix.env}/#{node()}'

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

import_config "secret.exs"
