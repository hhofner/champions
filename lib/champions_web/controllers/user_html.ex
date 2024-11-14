defmodule ChampionsWeb.UserHTML do
  use ChampionsWeb, :html

  def index(assigns) do
    ~H"""
    <div class="py-2">
      <h2 class="text-2xl font-bold text-primary"><%= @user.email %></h2>
    </div>
    """
  end
end
