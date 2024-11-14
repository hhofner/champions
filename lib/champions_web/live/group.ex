defmodule ChampionsWeb.GroupLive do
  use ChampionsWeb, :live_view

  def mount(%{"id" => group_id}, session, socket) do
        # <!-- <%= for member <- @group.members do %> -->
        # <!--   <div><%= member.name %></div> -->
        # <!-- <% end %> -->
    {:ok, assign(socket, group: Champions.Groups.get_group!(group_id))}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <h1 class="text-2xl font-semibold mb-6"><%= @group.name %></h1>
      <section>
        <h2 class="text-lg font-semibold">Members</h2>
      </section>
    </div>
    """
  end
end
