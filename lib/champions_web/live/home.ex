defmodule ChampionsWeb.HomeLive do
  use ChampionsWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    user = Champions.Accounts.get_user_by_session_token(session["user_token"])
    admin_groups = Champions.Groups.list_groups_admined_by_user(user.id)
    groups = Champions.Groups.list_groups_for_user(user.id)
    new_group_changeset = Champions.Groups.change_group(%Champions.Groups.Group{})

    socket =
      socket
      |> assign(
        admin_groups: admin_groups,
        groups: groups,
        show_create_group_modal: false,
        new_group_changeset: to_form(new_group_changeset),
        current_user_id: user.id
      )

    leagues = Champions.Games.list_leagues()

    socket =
      socket
      |> assign(available_leagues: create_league_options(leagues))

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_create_group_modal", _params, socket) do
    {:noreply, update(socket, :show_create_group_modal, &(!&1))}
  end

  @impl true
  def handle_event("create_new_group", %{"group" => group_params}, socket) do
    user_id = socket.assigns.current_user_id

    case Champions.Groups.create_group_with_user(group_params, user_id) do
      {:ok, _} ->
        socket =
          socket
          |> assign(show_create_group_modal: false)
          |> assign(
            admin_groups:
              Champions.Groups.list_groups_admined_by_user(socket.assigns.current_user_id),
            groups: Champions.Groups.list_groups_for_user(socket.assigns.current_user_id)
          )
          |> push_event("close_modal", %{to: "#close_modal_btn_create_group_modal"})

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, new_group_changeset: to_form(changeset))}
    end
  end

  def create_league_options(leagues) do
    leagues
    |> Enum.map(&{&1.name, &1.external_league_id})
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex-grow space-y-8">
      <section class="flex flex-col">
        <h1 class="text-2xl font-bold">Your Groups</h1>
        <%= for group <- @groups do %>
          <a class="link" href={~p"/groups/#{group.id}"}><%= group.name %></a>
        <% end %>
      </section>
      <section class="flex flex-col">
        <h1 class="text-2xl font-bold">Groups You're Admin Of</h1>
        <%= for group <- @admin_groups do %>
          <a class="link" href={~p"/groups/#{group.id}"}><%= group.name %></a>
        <% end %>
        <button class="btn btn-primary" phx-click={show_modal("create-group-modal")}>
          Create New Group
        </button>
      </section>
      <.modal id="create-group-modal">
        <h1 class="text-2xl font-bold text-primary">Create New Group</h1>
        <.simple_form for={@new_group_changeset} phx-submit="create_new_group">
          <.input field={@new_group_changeset[:name]} type="text" label="Name" />
          <.input
            field={@new_group_changeset[:league_id]}
            type="select"
            label="League"
            options={@available_leagues}
          />
          <div class="hidden">
            <.input
              field={@new_group_changeset[:owner]}
              type="text"
              label="Owner"
              value={@current_user_id}
            />
          </div>
          <:actions>
            <.button phx-disable-with="Creating..." class="btn btn-primary">Create</.button>
          </:actions>
        </.simple_form>
      </.modal>
    </div>
    """
  end
end
