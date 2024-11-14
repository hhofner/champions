# lib/your_app_web/live/fixture_live.ex
defmodule ChampionsWeb.FixtureLive do
  use ChampionsWeb, :live_view
  alias Champions.Football

  @impl true
  def mount(_params, _session, socket) do
    # if connected?(socket) do
    #   # Optional: Set up periodic updates
    #   :timer.send_interval(60_000, self(), :update_fixtures)
    # end

    {:ok,
     socket
     |> assign(:fixtures, [])
     |> assign(:loading, true)
     |> assign(:error, nil)
     |> fetch_fixtures()}
  end

  # @impl true
  # def handle_info(:update_fixtures, socket) do
  #   {:noreply, fetch_fixtures(socket)}
  # end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <h1 class="text-2xl font-semibold mb-6">Premier League Fixtures</h1>

      <%= if @loading do %>
        <div class="flex justify-center p-8">
          <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
        </div>
      <% end %>

      <%= if @error do %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative" role="alert">
          <span class="block sm:inline"><%= @error %></span>
        </div>
      <% end %>

      <%= if @fixtures != [] do %>
        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-300">
            <thead>
              <tr>
                <th class="px-3 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                <th class="px-3 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Home</th>
                <th class="px-3 py-3 bg-gray-50 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Score</th>
                <th class="px-3 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Away</th>
                <th class="px-3 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <%= for fixture <- @fixtures do %>
                <tr class="hover:bg-gray-50">
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    <%!-- <%= Calendar.strftime(fixture.date, "%Y-%m-%d %H:%M") %> --%>
                    <%= fixture.date %>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    <%= fixture.home_team %>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                    <%= fixture.score %>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    <%= fixture.away_team %>
                  </td>
                  <td class="px-3 py-4 whitespace-nowrap text-sm text-gray-500">
                    <span class={[
                      "px-2 inline-flex text-xs leading-5 font-semibold rounded-full",
                      status_color(fixture.status)
                    ]}>
                      <%= fixture.status %>
                    </span>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      <% end %>
    </div>
    """
  end

  defp fetch_fixtures(socket) do
    case Football.list_fixtures(39, 2024) do
      {:ok, fixtures} ->
        socket
        |> assign(:fixtures, fixtures)
        |> assign(:loading, false)
        |> assign(:error, nil)

      {:error, reason} ->
        socket
        |> assign(:loading, false)
        |> assign(:error, "Failed to load fixtures: #{inspect(reason)}")
    end
  end

  defp status_color(status) do
    case status do
      "LIVE" -> "bg-green-100 text-green-800"
      "FT" -> "bg-gray-100 text-gray-800"
      "NS" -> "bg-blue-100 text-blue-800"
      "HT" -> "bg-yellow-100 text-yellow-800"
      _ -> "bg-gray-100 text-gray-800"
    end
  end
end
