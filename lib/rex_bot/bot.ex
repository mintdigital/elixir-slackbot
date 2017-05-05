defmodule RexBot.Bot do
  ### Module Attributes ###
  @moduledoc """
  Will handle the messages sent via slack by taking the response,
  running it through `RexBot.Matcher.run_match/2` and returning a response
  to the user.
  """

  ### Use ###
  use Slack

  ### Aliases ###
  alias RexBot.Matcher

  ### Functions ###
  def start_link(initial_state) do
    Slack.start_link(__MODULE__, System.get_env("SLACK_API_TOKEN"), initial_state)
  end

  def init(initial_state, _slack), do: {:ok, initial_state}

  def handle_message({:type, "hello", _}, _slack, state) do
    {:ok, state}
  end

  def handle_message({:type, "message", response = %{text: text, team: team}}, slack, state) do
    text
    |> Matcher.run_match(team)
    |> Slack.send_message(response.channel, slack)

    {:ok, state}
  end

  def handle_message(_,_,state) do
    {:ok, state}
  end
end
