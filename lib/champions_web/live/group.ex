defmodule ChampionsWeb.GroupLive do
  use ChampionsWeb, :live_view

  def mount(%{"id" => group_id}, session, socket) do
    user = Champions.Accounts.get_user_by_session_token(session["user_token"])
    group_members = Champions.Groups.list_group_members(group_id)

    is_not_current_member = !Enum.member?(group_members, user)

    group = Champions.Groups.get_group!(group_id)
    league = Champions.Games.get_league!(group.league_id)

    # get current year in the format of "YYYY"
    current_year = DateTime.utc_now().year

    IO.inspect(league, label: "league")

    case Champions.Games.list_matches_current(league.external_league_id, current_year) do
      {:ok, fixtures} ->
        IO.inspect(fixtures, label: "fixtures")

        {:ok,
         assign(socket,
           group: group,
           group_members: group_members,
           is_not_current_member: is_not_current_member,
           league_name: league.name,
           user_id: user.id,
           fixtures: fixtures
         )}

      {:error, error} ->
        {:ok,
         assign(socket,
           group: group,
           group_members: group_members,
           is_not_current_member: is_not_current_member,
           league_name: league.name,
           user_id: user.id,
           fixtures: []
         )}
    end
  end

  @impl true
  def handle_event("join_group", _value, socket) do
    user_id = socket.assigns.user_id
    group_id = socket.assigns.group.id

    case Champions.Groups.create_group_membership(%{
           user_id: user_id,
           group_id: group_id,
           role: "member"
         }) do
      {:ok, _} ->
        socket =
          socket
          |> assign(is_not_current_member: false)
          |> assign(group_members: Champions.Groups.list_group_members(group_id))
          |> push_event("joined_group", %{})

        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <header class="flex gap-8 items-center">
        <h1 class="text-2xl font-semibold"><%= @group.name %></h1>
        <div><%= @league_name %></div>
        <button :if={@is_not_current_member} class="btn btn-neutral btn-sm" phx-click="join_group">
          Join
        </button>
        <button :if={!@is_not_current_member} class="btn btn-neutral btn-sm" disabled>
          Leave
        </button>
        <div></div>
      </header>
      <section>
        <h2 class="text-lg font-semibold">Members</h2>
        <ul>
          <%= for member <- @group_members do %>
            <li><%= member.email %></li>
          <% end %>
        </ul>
      </section>
      <section>
        <h2 class="text-lg font-semibold">Current Matchday</h2>
        <ul class="flex gap-5 flex-wrap">
          <%= for fixture <- @fixtures do %>
            <li class="">
              <h3><%= fixture.home_team %> - <%= fixture.away_team %></h3>
              <div>
                <h4>Your prediction:</h4>
                <div>
                  <input type="text" class="input input-bordered w-12" placeholder="0" />
                  <span>-</span>
                  <input type="text" class="input input-bordered w-12" placeholder="0" />
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </section>
    </div>
    """
  end
end
