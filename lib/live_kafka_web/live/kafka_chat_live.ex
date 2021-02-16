defmodule LiveKafkaWeb.KafkaChatLive do
  use Phoenix.LiveView
  use Phoenix.HTML
  alias LiveKafka.LiveUpdates

  @partition 0
  def render(assigns) do
    ~L"""
    <h2><%= @topic %></h2>
    <div phx-update="append">
    <%=for message <- @messages do %>
      <p id="<%= message.offset %>">
      <%= message.offset %>: <%= message.value %>
      </p>
    <% end %>
    </div>

    <div class="form-group">
    <%= form_for @changeset, "#", [phx_submit: :new_message], fn _f -> %>
      <%= text_input :new_message, :value, placeholder: "write your message here..." %>
      <%= hidden_input :new_message, :topic, value: @topic  %>
      <%= hidden_input :new_message, :user, value: "123"  %>
      <%= submit "submit" %>
      <% end %>
    </div>
    """
  end

  def mount(%{"topic" => topic} = _params, _session, socket) do
    LiveUpdates.subscribe_live_view(topic)
    [%{partition_offsets: [%{offset: [offset]}]}] = KafkaEx.latest_offset(topic, @partition)

    [%{partitions: [%{message_set: messages}]}] =
      KafkaEx.fetch(topic, @partition, offset: offset - 3)

    changeset = LiveKafka.Chat.form()

    socket =
      assign(socket, :topic, topic)
      |> assign(:offset, offset)
      |> assign(:messages, messages)
      |> assign(:changeset, changeset)

    {:ok, socket, temporary_assigns: [messages: []]}
  end

  def handle_info(message, socket) do
    IO.inspect(message)
    {:noreply, assign(socket, :messages, [message])}
  end

  def handle_event("new_message", %{"new_message" => message}, socket) do
    %{"topic" => topic, "user" => _user, "value" => value} = message
    KafkaEx.produce(topic, 0, value)
    {:noreply, socket}
  end
end
