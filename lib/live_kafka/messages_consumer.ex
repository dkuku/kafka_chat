defmodule MessagesConsumer do
  use KafkaEx.GenConsumer
  alias LiveKafka.LiveUpdates

  alias KafkaEx.Protocol.Fetch.Message

  require Logger

  def handle_message_set(message_set, state) do
    for %Message{topic: topic} = message <- message_set do
      LiveUpdates.notify_live_view(topic, message)
    end

    {:async_commit, state}
  end
end
