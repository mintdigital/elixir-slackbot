defmodule Elasticsearch do
  ### Module Attributes ###
  @moduledoc false
  @callback run_search(str :: String.t, team :: String.t) :: %Elasticsearch{}

  ### Use ###
  use Behaviour

  ### Structs ###
  defstruct question: "", answer: ""
end
