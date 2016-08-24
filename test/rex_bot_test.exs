defmodule RexBotTest do
  use ExUnit.Case
  doctest RexBot

  import Tirexs.Search
  import Tirexs.HTTP

  test "search documents inside of elasticsearch" do
    # Create the index
    put("/rex-test-questions")

    # Add questions to the index
    put("/rex-test-questions/questions/1", [question: "Where is the nearest Post Office to the UK office?"])
    put("/rex-test-questions/questions/2", [question: "Is there a cashpoint/ATM near the UK office?"])
    put("/rex-test-questions/questions/3", [question: "How do I find out how many days we've spent on a project?"])

    find_question = search [index: "rex-test-questions"] do
      query do
        string "question:UK"
      end
    end

    {:ok, 200, %{hits: %{hits: results}}} = Tirexs.Query.create_resource(find_question)
    expected = [
      "Is there a cashpoint/ATM near the UK office?",
      "Where is the nearest Post Office to the UK office?"
    ]
    actual = results |> (Enum.map fn(doc) -> doc[:_source].question end)

    assert Enum.sort(actual) == Enum.sort(expected)
  end
end
