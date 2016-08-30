defmodule Elasticsearch.InMemory.Fail do
  ### Module Attributes ###
  @behaviour Elasticsearch

  ### Functions ###
  @spec run_search(String.t, String.t) :: %Elasticsearch{}
  def run_search(_, _) do
    %Elasticsearch {
      :question => "",
      :answer   => ""
    }
  end
end
