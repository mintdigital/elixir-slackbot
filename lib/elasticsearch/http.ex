defmodule Elasticsearch.HTTP do
  ### Module Attributes ###
  @moduledoc """
  Provides the `search` function which takes a `str` and a `team` ID.
  It will perform an ElasticSearch search based on the parameters you provide.

  If ES finds any matches it will return a struct like so
  `%ElasticSearch{question: "", answer: ""}`, if there are no matches OR if
  ES fails it will return an empty array.
  """
  @behaviour Elasticsearch
  @elasticsearch_index_name Application.get_env(:rex_bot, :elasticsearch_index_name)

  ### Import ###
  import Tirexs.Search

  ### Functions ###
  @spec run_search(str :: String.t, team :: String.t) :: %Elasticsearch{}
  def run_search(str, team) do
    run_elasticsearch_query(str, team) |> format_response
  end

  @spec run_elasticsearch_query(str :: String.t, team :: String.t) :: tuple
  defp run_elasticsearch_query(str, team) do
    query = search [index: @elasticsearch_index_name] do
      query do
        filtered do
          query do
            match "question", str
          end
          filter do
            match "team", team
          end
        end
      end
    end

    Tirexs.Query.create_resource(query)
  end

  @spec format_response(tuple) :: %Elasticsearch{}
  defp format_response({:ok, 200, %{hits: %{hits: []}}}), do: %Elasticsearch{}
  defp format_response({:ok, 200, %{hits: %{hits: responses}}}) do
    results = (responses |> List.first)
    %Elasticsearch{
      question: results[:_source][:question],
      answer:   results[:_source][:answer]
    }
  end
  defp format_response(_), do: %Elasticsearch{}
end
