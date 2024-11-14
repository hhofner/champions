defmodule ChampionsWeb.UserController do
  use ChampionsWeb, :controller

  def index(conn, _params) do
    user = Champions.Accounts.get_user!(conn.params["id"])
    render(conn, :index, user: user)
  end
end
