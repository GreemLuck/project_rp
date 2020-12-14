defmodule ProjectRpWeb.RoomChannel do
  use ProjectRpWeb, :channel

  alias ProjectRpWeb.Presence

  @impl true
  def join(channel_name, payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      IO.inspect socket
      {:ok, %{channel: channel_name}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    ProjectRp.Message.changeset(%ProjectRp.Message{}, payload) |> ProjectRp.Repo.insert()
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("command", payload, socket) do
    push(socket, "command", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("leave", payload, socket) do
    broadcast(socket, "leave", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("join", payload, socket) do
    broadcast(socket, "join", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    #ProjectRp.Message.get_messages()
    #|> Enum.each(fn msg -> push(socket, "shout", %{name: msg.name, message: msg.message}) end)



    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
