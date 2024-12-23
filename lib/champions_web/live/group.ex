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
        predictions =
          Champions.Predictions.list_matchday_predictions(user.id, Enum.map(fixtures, & &1.id))

        # I want to do something like predictions.find(id => fixture.id)?.predicted_home_score || ""

        fixture_map =
          Enum.reduce(fixtures, %{}, fn fixture, acc ->
            home_score =
              Enum.find_value(predictions, "", fn pred ->
                pred.match_id == fixture.id && pred.predicted_home_score
              end) || ""

            away_score =
              Enum.find_value(predictions, "", fn pred ->
                pred.match_id == fixture.id && pred.predicted_away_score
              end) || ""

            acc
            |> Map.put("#{fixture.id}-home", home_score)
            |> Map.put("#{fixture.id}-away", away_score)
          end)

        form = to_form(fixture_map)

        IO.inspect(predictions, label: "found predictions")

        {:ok,
         assign(socket,
           group: group,
           group_members: group_members,
           is_not_current_member: is_not_current_member,
           league_name: league.name,
           user_id: user.id,
           fixtures: fixtures,
           predictions: predictions,
           form: form
         )}

      {:error, error} ->
        form = to_form(%{})

        {:ok,
         assign(socket,
           group: group,
           group_members: group_members,
           is_not_current_member: is_not_current_member,
           league_name: league.name,
           user_id: user.id,
           predictions: [],
           fixtures: [],
           form: form
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

  def handle_event("check", params, socket) do
    %{"_target" => target} = params
    target_match = Enum.at(target, 0)
    new_val = params[target_match]

    match_id = String.split(target_match, "-") |> Enum.at(0) |> String.to_integer()
    side = String.split(target_match, "-") |> Enum.at(1)
    user_id = socket.assigns.user_id

    prediction =
      Enum.find(socket.assigns.predictions, fn pred ->
        # Just compare with the converted match_id
        pred.match_id == match_id
      end)

    # Convert new_val to integer if it's not empty
    new_val = if new_val == "", do: nil, else: String.to_integer(new_val)

    update_attrs =
      case side do
        "home" -> %{predicted_home_score: new_val}
        "away" -> %{predicted_away_score: new_val}
      end

    case prediction do
      nil ->
        full_attrs =
          case side do
            "home" ->
              Map.merge(update_attrs, %{
                user_id: user_id,
                match_id: match_id,
                # Changed from "" to nil
                predicted_away_score: nil
              })

            "away" ->
              Map.merge(update_attrs, %{
                user_id: user_id,
                match_id: match_id,
                # Changed from "" to nil
                predicted_home_score: nil
              })
          end

        case Champions.Predictions.create_prediction(full_attrs) do
          {:ok, new_prediction} ->
            predictions = [new_prediction | socket.assigns.predictions]
            {:noreply, assign(socket, predictions: predictions)}

          {:error, changeset} ->
            IO.inspect(changeset, label: "creation error")
            {:noreply, socket}
        end

      prediction ->
        case Champions.Predictions.update_prediction(prediction, update_attrs) do
          {:ok, _} -> {:noreply, socket}
          {:error, _} -> {:noreply, socket}
        end
    end
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
        <.simple_form for={@form} phx-change="check">
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
                    <.input
                      field={@form["#{fixture.id}-home"]}
                      phx-debounce="blur"
                      type="number"
                      name={"#{fixture.id}-home"}
                      placeholder="0"
                    />
                    <span class="font-bold">-</span>
                    <.input
                      field={@form["#{fixture.id}-away"]}
                      phx-debounce="blur"
                      type="number"
                      name={"#{fixture.id}-away"}
                      placeholder="0"
                    />
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </.simple_form>
      </section>
    </div>
    """
  end
end
