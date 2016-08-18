defmodule RexSlackTest do
  use ExUnit.Case
  doctest RexSlack

  import Tirexs.Search
  import Tirexs.HTTP
  require Logger

  test "search documents inside of elasticsearch" do
    put("/questions-search-index/questions/1", [question: "Where is the nearest Post Office to the UK office?"])
    put("/questions-search-index/questions/2", [question: "Is there a cashpoint/ATM near the UK office?"])
    put("/questions-search-index/questions/3", [question: "How do I find out how many days we've spent on a project?"])

    find_question = search [index: "questions-search-index"] do
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

    assert actual == expected
  end
end
