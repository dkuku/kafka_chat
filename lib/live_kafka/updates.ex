defmodule LiveKafka.LiveUpdates do
  @topic inspect(__MODULE__)

  @doc "subscribe for all topics"
  def subscribe_live_view do
    Phoenix.PubSub.subscribe(LiveKafka.PubSub, topic(), link: true)
  end

  @doc "subscribe for specific topic"
  def subscribe_live_view(topic_id) do
    Phoenix.PubSub.subscribe(LiveKafka.PubSub, topic(topic_id), link: true)
  end

  @doc "notify for all topics"
  def notify_live_view(message) do
    Phoenix.PubSub.broadcast(LiveKafka.PubSub, topic(), message)
  end

  @doc "notify for specific topic"
  def notify_live_view(topic_id, message) do
    Phoenix.PubSub.broadcast(LiveKafka.PubSub, topic(topic_id), message)
  end

  defp topic, do: @topic
  defp topic(topic_id), do: topic() <> to_string(topic_id)
end
