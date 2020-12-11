defmodule ProjectRp.MessageHandler do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:sent, payload, socket}, state) do

    case payload do
      %{"message" => "/"<>_} -> ProjectRpWeb.Endpoint.broadcast(socket[:topic], "command", payload)
      %{"message" => _}->  ProjectRp.Message.changeset(%ProjectRp.Message{}, payload) |> ProjectRp.Repo.insert()
      ProjectRpWeb.Endpoint.broadcast(Map.fetch!(socket, :topic),"shout",payload)
    end
    {:noreply, state}
  end

end
