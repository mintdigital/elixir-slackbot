defmodule RexBot.Mixfile do
  use Mix.Project

  def project do
    [app: :rex_bot,
     version: "0.1.0",
     elixir: "~> 1.4.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :slack, :tirexs],
     mod: {RexBot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:slack, "~> 0.0.5"},
      {:tirexs, "~> 0.8"},
      {:exjsx, "~> 3.2.0", override: true},
      {:websocket_client, github: "jeremyong/websocket_client"},
      {:ex_doc, github: "elixir-lang/ex_doc"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:distillery, "~> 0.9"}
    ]
  end
end
