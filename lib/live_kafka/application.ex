defmodule LiveKafka.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use KafkaEx.GenConsumer

  def start(_type, _args) do
    import Supervisor.Spec

    consumer_group_opts = [
      # setting for the ConsumerGroup
      heartbeat_interval: 1_000,
      # this setting will be forwarded to the GenConsumer
      commit_interval: 1_000
    ]

    gen_consumer_impl = MessagesConsumer
    consumer_group_name = "kuku"
    topic_names = ["kuku-test"]

    children = [
      # Start the Ecto repository
      LiveKafka.Repo,
      # Start the Telemetry supervisor
      LiveKafkaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveKafka.PubSub},
      # Start the Endpoint (http/https)
      LiveKafkaWeb.Endpoint,
      supervisor(
        KafkaEx.ConsumerGroup,
        [gen_consumer_impl, consumer_group_name, topic_names, consumer_group_opts]
      )
      # Start a worker by calling: LiveKafka.Worker.start_link(arg)
      # {LiveKafka.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveKafka.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveKafkaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
