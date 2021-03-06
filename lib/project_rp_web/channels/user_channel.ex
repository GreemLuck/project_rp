defmodule ProjectRpWeb.UserChannel do
  use ProjectRpWeb, :channel

  alias ProjectRpWeb.Presence

  @impl true
  def join("user:"<>username, payload, socket) do
    if authorized?(payload) do
      {:ok, %{channel: "user:"<>username}, socket}
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
  # broadcast to everyone in the current topic (user:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  @impl true
  def handle_in("whisper", payload, socket) do
    push socket, "whisper", payload
    ProjectRpWeb.Endpoint.broadcast "user:"<>Map.fetch!(payload, "dest"), "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
