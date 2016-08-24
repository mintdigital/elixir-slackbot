defmodule ElasticsearchTest do
  use ExUnit.Case, async: true
  doctest Elasticsearch

  import Tirexs.Search
  import Tirexs.HTTP

  test "return the most relevant question and answer" do
    # Create the index
    put("/rex-test-questions")

    # Add questions to the index
    put("/rex-test-questions/questions/1", [question: "Where is the nearest Post Office to the UK office?", team: "ER70"])
    put("/rex-test-questions/questions/2", [question: "Is there a cashpoint/ATM near the UK office?", team: "AER78"])
    put("/rex-test-questions/questions/3", [question: "How do I find out how many days we've spent on a project?", team: "AER78"])

    assert Elasticsearch.search("UK", "ER70") == %{question: "Where is the nearest Post Office to the UK office?", answer: "My answer..."}
  end

  test "should return no records if it cannot find a question that is relevant" do
  end

  test "should not return records from another team" do
  end
end
