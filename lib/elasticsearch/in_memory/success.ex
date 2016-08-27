defmodule Elasticsearch.InMemory.Success do
  ### Module Attributes ###
  @behaviour Elasticsearch

  ### Functions ###
  def run_search(_, _) do
    %Elasticsearch {
      :question => "Where is the nearest Post Office to the UK office?",
      :answer   => "Next to sainsburys"
    }
  end
end
