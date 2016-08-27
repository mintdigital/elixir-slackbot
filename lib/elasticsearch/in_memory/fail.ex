defmodule Elasticsearch.InMemory.Fail do
  ### Module Attributes ###
  @behaviour Elasticsearch

  ### Functions ###
  def run_search(_, _) do
    %Elasticsearch {
      :question => "",
      :answer   => ""
    }
  end
end
