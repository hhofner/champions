defmodule Champions.Football.Client do
  @moduledoc """
  The API client implementation - handles the raw HTTP communication
  """
  @base_url "https://api-football-v1.p.rapidapi.com"

  defp client do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      {Tesla.Middleware.Headers,
       [
         # this comes from the .env file
         {"x-rapidapi-key", api_key()},
         # this comes from the .env file
         {"x-rapidapi-host", api_host()},
         {"Content-Type", "application/json"}
       ]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware, {Tesla.Adapter.Finch, name: Champions.Finch})
  end

  defp api_key, do: Application.get_env(:champions, :football_api_key)
  defp api_host, do: "api-football-v1.p.rapidapi.com"

  @spec get_fixtures(String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  def get_fixtures(league_id, season) do
    client()
    |> Tesla.get("/v3/fixtures", query: [league: league_id, season: season])
    |> handle_response()
  end

  @spec get_current_matchday_fixtures(String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  def get_current_matchday_fixtures(league_id, season) do
    with {:ok, response} <-
           client()
           |> Tesla.get("/v3/fixtures/rounds",
             query: [league: league_id, season: season, current: true]
           )
           |> handle_response(),
         current_matchday = response["response"] |> Enum.at(0),
         {:ok, fixtures} <-
           client()
           |> Tesla.get("/v3/fixtures",
             query: [league: league_id, season: season, round: current_matchday]
           )
           |> handle_response() do
      {:ok, fixtures}
    end
  end

  @spec get_standings(String.t(), String.t()) :: {:ok, any()} | {:error, any()}
  def get_standings(league_id, season) do
    client()
    |> Tesla.get("/v3/standings", query: [league: league_id, season: season])
    |> handle_response()
  end

  def get_leagues do
    client()
    |> Tesla.get("/v3/leagues")
    |> handle_response()
  end

  defp handle_response({:ok, %{status: 200, body: body}}), do: {:ok, body}
  defp handle_response({:ok, %{status: status, body: body}}), do: {:error, {status, body}}
  defp handle_response({:error, error}), do: {:error, error}
end
