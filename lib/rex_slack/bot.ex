defmodule RexSlack.Bot do
  use Slack
  import Tirexs.Search
  import Tirexs.HTTP


  # So we'll define a start_link function, and we'll defer to the
  # Slack.start_link function, passing it our API Token
  def start_link(initial_state) do
    Slack.start_link(__MODULE__, "xoxb-70074277063-adbl3wsCtVW3AnIQ7Jxw4L5H", initial_state)
  end

  def init(initial_state, _slack), do: {:ok, initial_state}
  def handle_connect(slack), do: IO.puts "Connected as #{slack.me.name}"

  def handle_message({:type, "hello", _}, _slack, state), do: {:ok, state}
  def handle_message({:type, "message", response = %{text: text, team: team}}, slack, state) do
    # While our bot is connected, we'll send an upcased reply to all messages
    text
    |> regex_message(team)
    |> Slack.send_message(response.channel, slack)

    {:ok, state}
  end
  def handle_message(_,_,state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack) do
    Slack.send_message(text, channel, slack)
    {:ok}
  end
  def handle_info(_, _), do: :ok

  defp regex_message(str, team) do
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
      Regex.match?(~r/^(hello|hey|hi|yo|sup|holla|good morning|good afternoon)$/i, str) -> get_random_hello_response
      Regex.match?(~r/^(thanks|cheers|thank you|thankyou|thank-you|ta|nice one)$/i, str) -> get_random_thanks_response
      true -> elastic_search(str, team)
    end
  end

  defp elastic_search(str, team) do
    get("/rex-questions/_search?q=question:#{URI.encode(str)}&must:team_id:#{team}") |> elastic_result
  end

  defp elastic_result({:ok, 200, %{hits: %{hits: []}}}), do: get_no_answer_response
  defp elastic_result({:ok, 200, %{hits: %{hits: results}}}) do
    results = (results |> List.first)
    "*Q: #{results[:_source][:question]}*\nA: #{results[:_source][:answer]}"
  end
  defp elastic_result(_), do: get_no_answer_response

  defp get_random_hello_response do
    Enum.random(["Hi there!", "Here I am!", "Yo!", "Hey there!", "G'day!", "Rex at your service!", "Woof!"])
  end

  defp get_random_thanks_response do
    Enum.random(["You're welcome!", "Glad to help!", "No problemo!", "My pleasure!", "Piece of cake!"])
  end

  def get_no_answer_response do
    Enum.random(["Sorry, I don’t have an answer to that one right now.", "Hmm, not sure I can answer that one. Sorry!"])
  end
end
