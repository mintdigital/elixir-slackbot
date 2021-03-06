defmodule Elasticsearch.InMemory.Success do
  ### Module Attributes ###
  @moduledoc """
  Acts as a success mock for the `Elasticsearch.HTTP` module.
  """
  @behaviour Elasticsearch

  ### Functions ###
  @spec run_search(_ :: String.t, _ :: String.t) :: %Elasticsearch{}
  def run_search(_, _) do
    %Elasticsearch {
      :question => "Where is the nearest Post Office to the UK office?",
      :answer   => "Next to sainsburys"
    }
  end
end
