defmodule ProjectRpWeb.PageController do
  use ProjectRpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
