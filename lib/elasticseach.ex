defmodule Elasticsearch do
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
