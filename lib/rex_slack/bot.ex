defmodule RexSlack.Bot do
  use Slack
  import Tirexs.Search
  import Tirexs.HTTP
  require Logger

  # So we'll define a start_link function, and we'll defer to the
  # Slack.start_link function, passing it our API Token
  def start_link(initial_state) do
    Logger.debug inspect initial_state
    Slack.start_link(__MODULE__, "xoxb-70074277063-adbl3wsCtVW3AnIQ7Jxw4L5H", initial_state)
  end

  def init(initial_state, slack), do: {:ok, initial_state}
  def handle_connect(slack), do: IO.puts "Connected as #{slack.me.name}"

  def handle_message({:type, "hello", _}, slack, state), do: {:ok, state}
  def handle_message({:type, "message", response = %{text: text}}, slack, state) do
    Logger.debug inspect "1"
    Logger.debug inspect response
    # While our bot is connected, we'll send an upcased reply to all messages
    text
    |> regex_message
    |> Slack.send_message(response.channel, slack)

    {:ok, state}
  end
  def handle_message(_,_,state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack) do
    Slack.send_message(text, channel, slack)
    {:ok}
  end
  def handle_info(_, _), do: :ok

  defp regex_message(str) do
    cond do
      Regex.match?(~r/^woof$/i, str) -> "Woof back atcha!"
      Regex.match?(~r/^stupid dog$/i, str) -> "Just so you know - this stupid dog was programmed by stupid humans."
      Regex.match?(~r/^walkies$/i, str) -> "LET’S GO ALREADY!!!!!!!!!!!!"
      Regex.match?(~r/^roll over$/i, str) -> "There better be a treat at the end of this..."
      Regex.match?(~r/^shake a paw$/i, str) -> "Hard... to type... with… one paw..."
      Regex.match?(~r/^sit$/i, str) -> "I prefer to use a standing desk."
      Regex.match?(~r/^good boy$/i, str) -> "Aw, shucks. Just doing my job."
      Regex.match?(~r/^stay$/i, str) -> "Dude, I’m right here."
      Regex.match?(~r/^leave it$/i, str) -> "Leave what where?"
      Regex.match?(~r/^drop it$/i, str) -> "...like it’s hot, drop it like it’s hot, drop it like it’s hot..."
      Regex.match?(~r/^lie down$/i, str) -> "You want me to take the day off? Fine by me!"
      Regex.match?(~r/^heel$/i, str) -> "I think you’ve confused me with a chiropodist."
      Regex.match?(~r/^speak$/i, str) -> "Je m'appelle Rex. J'aime les treats."
      true -> elastic_search(str)
    end
  end

  defp elastic_search(str) do
    find_question = search [index: "rex-questions"] do
      query do
        match "question", str
      end
    end

    Tirexs.Query.create_resource(find_question) |> elastic_result
  end

  defp elastic_result({:ok, 200, %{hits: %{hits: []}}}) do
    "Sorry! I do not have an answer for your question."
  end

  defp elastic_result({:ok, 200, %{hits: %{hits: results}}}) do
    results = (results |> List.first)
    "*Q: #{results[:_source][:question]}*\nA: #{results[:_source][:answer]}"
  end
end
