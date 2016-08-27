defmodule Elasticsearch do
  use Behaviour

  @callback search(String.t, String.t) :: %Elasticsearch{}
end
