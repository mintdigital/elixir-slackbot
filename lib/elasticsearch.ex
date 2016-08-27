defmodule Elasticsearch do
  use Behaviour
  defstruct question: "", answer: ""

  @callback run_search(str :: String.t, team :: String.t) :: %Elasticsearch{}
end
