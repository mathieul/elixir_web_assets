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
      { :cowboy, github: "extend/cowboy" },
      { :dynamo, github: "fenfir/dynamo", ref: "dea4787f3a67f626e086ec2bbfca70b16abe20c5" } ]
  end
end
