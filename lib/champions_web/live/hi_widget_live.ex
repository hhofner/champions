defmodule ChampionsWeb.HiWidgetLive do
  use ChampionsWeb, :live_view
  on_mount {ChampionsWeb.UserAuth, :mount_current_user}

  # def mount(_params, session, socket) do
  #   with token when is_bitstring(token) <- session["user_token"],
  #     user when not is_nil(user) <- Champions.Accounts.get_user_by_session_token(token) do
  #     {:ok, assign(socket, current_user: user)}
  #   else
  #     _ -> {:ok, socket}
  #   end
  # end
  def render(assigns) do
    if assigns[:current_user] do
      ~H"""
      <div>Hi, <%= @current_user.email %></div>
      """
    else
      ~H"""
      <div>Please log in</div>
      """
    end
  end
end
