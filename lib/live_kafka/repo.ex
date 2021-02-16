defmodule LiveKafka.Repo do
  use Ecto.Repo,
    otp_app: :live_kafka,
    adapter: Ecto.Adapters.Postgres
end
