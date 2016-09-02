defmodule RexBot do
  ### Module Attributes ###
  @moduledoc false

  ### Use ###
  use Application

  ### Functions ###
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: RexBot.Worker.start_link(arg1, arg2, arg3)
      worker(RexBot.Bot, [[]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RexBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
