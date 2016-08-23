defmodule Matcher do
  def run_match(str, team) do
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
      true -> Elasticsearch.search(str, team) |> es_response
    end
  end

  defp get_random_hello_response do
    ["Hi there!", "Here I am!", "Yo!", "Hey there!", "G'day!", "Rex at your service!", "Woof!"] |> Enum.random
  end

  defp get_random_thanks_response do
    ["You're welcome!", "Glad to help!", "No problemo!", "My pleasure!", "Piece of cake!"] |> Enum.random
  end

  def es_response([]) do
    [
      "Sorry, I don’t have an answer to that one right now.",
      "Hmm, not sure I can answer that one. Sorry!"
    ]
    |> Enum.random
  end

  def es_response(%Elasticsearch{question: question, answer: answer}) do
    "*Q: #{question}*\nA: #{answer}"
  end
end
