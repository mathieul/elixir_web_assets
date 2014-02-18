defmodule ElixirWebAssets.Mixfile do
  use Mix.Project

  def project do
    [ app: :elixir_web_assets,
      version: "0.0.1",
      elixir: "~> 0.12.1-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { ElixirWebAssets, [] }]
  end

  defp deps do
    [ { :exactor, github: "sasa1977/exactor" },
      { :exjson, github: "guedes/exjson" },
      { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "dynamo/dynamo" } ]
  end
end
