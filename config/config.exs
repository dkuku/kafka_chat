# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :live_kafka,
  ecto_repos: [LiveKafka.Repo]

# Configures the endpoint
config :live_kafka, LiveKafkaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "toIxkMqipBwGdd1WW1d53lI4TU55iqurXGz9FRWVJXJ+7krSBTuYqIwUCBCU6z1i",
  render_errors: [view: LiveKafkaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveKafka.PubSub,
  live_view: [signing_salt: "1powjDav"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kafka_ex,
  brokers: [{"127.0.0.1", 9092}]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
