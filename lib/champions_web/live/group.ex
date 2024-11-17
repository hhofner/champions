defmodule ChampionsWeb.GroupLive do
  use ChampionsWeb, :live_view

  def mount(%{"id" => group_id}, session, socket) do
    user = Champions.Accounts.get_user_by_session_token(session["user_token"])
    group_members = Champions.Groups.list_group_members(group_id)

    is_not_current_member = !Enum.member?(group_members, user)

    {:ok,
     assign(socket,
       group: Champions.Groups.get_group!(group_id),
       group_members: group_members,
       is_not_current_member: is_not_current_member
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <header class="flex gap-8">
        <h1 class="text-2xl font-semibold mb-6"><%= @group.name %></h1>
        <button :if={@is_not_current_member} class="btn btn-neutral btn-sm">Join</button>
      </header>
      <section>
        <h2 class="text-lg font-semibold">Members</h2>
        <ul>
          <%= for member <- @group_members do %>
            <li><%= member.email %></li>
          <% end %>
        </ul>
      </section>
    </div>
    """
  end
end
