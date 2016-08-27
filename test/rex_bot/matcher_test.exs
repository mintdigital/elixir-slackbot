defmodule RexBot.MatcherTest do
  use ExUnit.Case, async: true
  doctest RexBot.Matcher

  ### Module Attributes ###
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

  ### Tests ###
  test "should match canned response for woof" do
    matcher_reponse = RexBot.Matcher.run_match("woof", nil)
    assert matcher_reponse == "Woof back atcha!"
  end

  test "should match one of the canned hello reponse" do
    matcher_reponse = RexBot.Matcher.run_match("Hello", nil)
    assert Enum.any?(@hello_responses, &(&1 == matcher_reponse))
  end

  test "should match a canned thanks reponse" do
    matcher_reponse = RexBot.Matcher.run_match("Thanks", nil)
    assert Enum.any?(@thanks_responses, &(&1 == matcher_reponse))
  end

  test "should return a reponse when a question is matched" do
    matcher_reponse = RexBot.Matcher.run_match(
      "Where is the nearest Post Office?",
      nil,
      Elasticsearch.InMemory.Success
    )
    assert matcher_reponse == "*Q: Where is the nearest Post Office to the UK office?*\nA: Next to sainsburys"
  end

  test "should return a no reply reponse if there is no match" do
    matcher_reponse = RexBot.Matcher.run_match(
      "Toilet",
      nil,
      Elasticsearch.InMemory.Fail
    )
    assert Enum.any?(@no_reply_responses, &(&1 == matcher_reponse))
  end
end
