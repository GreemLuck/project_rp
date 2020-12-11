defmodule ProjectRpWeb.Helpers.Auth do
  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: !!ProjectRp.Repo.get(ProjectRp.Accounts.User, user_id)
  end

  def current_user(conn) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
    if user_id, do: ProjectRp.Repo.get(ProjectRp.Accounts.User, user_id)
  end

  def user_signed_in?(conn) do
    !!current_user(conn)
  end
end
