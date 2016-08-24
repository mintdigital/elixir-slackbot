defmodule Elasticsearch do
  @moduledoc """
  Provides the `search` function which takes a `str` and a `team` ID.
  It will perform an ElasticSearch search based on the parameters you provide.

  If ES finds any matches it will return a struct like so
  `%ElasticSearch{question: "", answer: ""}`, if there are no matches OR if
  ES fails it will return an empty array.
  """
  import Tirexs.HTTP
  defstruct question: "", answer: ""

  def search(str, team) do
    get("/#{System.get_env("ELASTIC_SEARCH_INDEX_NAME")}/_search?q=question:#{URI.encode(str)}&must:team_id:#{team}")
    |> format_response
  end

  defp format_response({:ok, 200, %{hits: %{hits: []}}}), do: []

  defp format_response({:ok, 200, %{hits: %{hits: results}}}) do
    results = (results |> List.first)
    %Elasticsearch{
      question: results[:_source][:question],
      answer:   results[:_source][:answer]
    }
  end

  defp format_response(_), do: []
end
