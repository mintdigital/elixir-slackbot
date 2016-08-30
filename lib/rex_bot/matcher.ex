defmodule RexBot.Matcher do
  ### Module Attributes ###
  @moduledoc """
  Provides the run_match function which will take a string and a team ID.
  It will first check to see if the give string has a canned reponse, if
  it does it will return the specified string.

  If it fails to match a canned reponse it will serach ElasticSearch
  for a question that could be relevant. If it finds a question that is
  relevant we will returned the stored answer. If it fails to find a match
  we return a standard reponse that is stored in @no_reply_response.
  """

  @hello_responses    [
    "Hi there!",
    "Here I am!",
    "Yo!",
    "Hey there!",
    "G'day!",
    "Rex at your service!",
    "Woof!"
  ]

  @thanks_responses   [
    "You're welcome!",
    "Glad to help!",
    "No problemo!",
    "My pleasure!",
    "Piece of cake!"
  ]

  @no_reply_responses  [
    "Sorry, I don’t have an answer to that one right now.",
    "Hmm, not sure I can answer that one. Sorry!"
  ]

  ### Functions ###
  @doc ~S"""
  Reponds with the most appropriate answer to the question given via `str`

  Returns a string.

  ## Examples

    iex> RexBot.Matcher.run_match("woof", nil)
    "Woof back atcha!"

  """
  @spec run_match(str :: String.t, team :: String.t, elasticsearch_api :: any) :: String.t
  def run_match(str, team, elasticsearch_api \\ Elasticsearch.HTTP) do
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
      true -> elasticsearch_api.run_search(str, team) |> elasticsearch_response
    end
  end

  @spec get_random_hello_response :: String.t
  defp get_random_hello_response do
    @hello_responses |> Enum.random
  end

  @spec get_random_thanks_response :: String.t
  defp get_random_thanks_response do
    @thanks_responses |> Enum.random
  end

  @spec elasticsearch_response(map) :: String.t
  def elasticsearch_response(%{question: "", answer: ""}) do
   @no_reply_responses |> Enum.random
  end

  def elasticsearch_response(%{question: question, answer: answer}) do
    "*Q: #{question}*\nA: #{answer}"
  end
end
