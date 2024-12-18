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

    case Champions.Games.list_matches_current(league.external_league_id, current_year) do
      {:ok, fixtures} ->
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

  def handle_event(
        "update_prediction",
        %{"_target" => [team], "away-team" => away_team, "home-team" => home_team} = params,
        socket
      ) do
    IO.inspect(params, label: "All params")
    IO.inspect(home_team, label: "home_team")
    IO.inspect(away_team, label: "away_team")

    {:noreply, socket}
  end

  # Add a catch-all clause to handle partial updates
  def handle_event("update_prediction", params, socket) do
    IO.inspect(params, label: "Partial update params")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <a class="link" href={~p"/home"}>← Back to home</a>
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
      <section class="p-4">
        <h2 class="text-lg font-semibold mb-4">Current Matchday</h2>
        <form class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <%= for fixture <- @fixtures do %>
            <div class="border rounded-lg p-4 shadow-sm">
              <div class="flex flex-col space-y-3">
                <div class="grid grid-cols-[1fr_auto_1fr] gap-2 items-center">
                  <div class="text-right truncate" title={fixture.home_team}>
                    <%= fixture.home_team %>
                  </div>
                  <div class="font-bold">vs</div>
                  <div class="truncate" title={fixture.away_team}>
                    <%= fixture.away_team %>
                  </div>
                </div>

                <div class="space-y-2">
                  <h4 class="text-sm font-medium text-gray-600">Your prediction:</h4>
                  <div class="flex items-center justify-center gap-2">
                    <input
                      type="text"
                      class="input input-bordered w-16 text-center"
                      name="home-team"
                      placeholder="0"
                      phx-change="update_prediction"
                      phx-value-match-id={fixture.id}
                    />
                    <span class="font-bold">-</span>
                    <input
                      type="text"
                      class="input input-bordered w-16 text-center"
                      name="away-team"
                      placeholder="0"
                      phx-change="update_prediction"
                      phx-value-match-id={fixture.id}
                    />
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </form>
      </section>
    </div>
    """
  end
end
