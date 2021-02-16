defmodule LiveKafkaWeb.PageLive do
  use LiveKafkaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    %{topic_metadatas: metadata} = KafkaEx.metadata()
    {:ok, assign(socket, metadata: metadata)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: query, query: query)}
  end
end
