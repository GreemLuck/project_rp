defmodule ProjectRp.Repeater do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    # This should send a message to say the Repeater is starting, but we can't seem to see it on the chat. Maybe is it to fast or to early.
    ProjectRpWeb.Endpoint.broadcast "room:lobby", "shout", %{name: "Server", message: "Repeater Started"}
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:test}, test) do
    :io.format("~ntest~n", [])
    {:noreply, test}
  end
end
