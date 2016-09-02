defmodule Elasticsearch.HTTPTest do
  use ExUnit.Case, async: true

  ### Module Attributes ###
  @moduletag :elasticsearch_api
  @elasticsearch_index_name Application.get_env(:rex_bot, :elasticsearch_index_name)

  ### Aliases ###
  alias Tirexs.HTTP, as: THTTP

  setup_all do
    # Create the index
    THTTP.put("/#{@elasticsearch_index_name}")

    # Add questions to the index
    THTTP.put("/#{@elasticsearch_index_name}/questions/1", [
      question: "Where is the nearest Post Office to the UK office?",
      answer:   "Around the corner, outside sainsburys",
      team:     "ER70",
    ])

    THTTP.put("/#{@elasticsearch_index_name}/questions/2", [
      question: "Is there a cashpoint/ATM near the UK office?",
      answer:   "Around the corner, outside tesco",
      team:     "AER78"
    ])

    THTTP.put("/#{@elasticsearch_index_name}/questions/3", [
      question: "How do I find out how many days we've spent on a project?",
      answer:   "10,000ft is the place for you!",
      team:     "AER78"
    ])

    :ok
  end

  test "return the most relevant question and answer to the given team" do
    assert Elasticsearch.HTTP.run_search(
      "Where is the nearest Post Office to the UK office?",
      "ER70"
    ) == %Elasticsearch{
      question: "Where is the nearest Post Office to the UK office?",
      answer:   "Around the corner, outside sainsburys"
    }
  end

  test "should return no records if it cannot find a question that is relevant" do
    assert Elasticsearch.HTTP.run_search(
      "toilet?",
      "ER70"
    ) == %Elasticsearch{ question: "", answer:   "" }
  end

  test "should not return records from another team" do
    assert Elasticsearch.HTTP.run_search(
      "Cashpoint?",
      "ER70"
    ) == %Elasticsearch{ question: "", answer: "" }
  end
end
