defmodule ElixirWebAssets.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(ElixirWebAssets.AssetPipeline, [ asset_pipeline_config ])
    ]
    supervise(children, strategy: :one_for_one)
  end

  defp asset_pipeline_config do
    config = Mix.project[:elixir_web_assets] || Keyword.new
    [
      script_path: Keyword.get(config, :script_path, Path.expand("assets/javascripts")),
      script_load_paths: Keyword.get(config, :script_load_paths, []),
      stylesheet_path: Keyword.get(config, :stylesheet_path, Path.expand("assets/stylesheets")),
      stylesheet_load_paths: Keyword.get(config, :stylesheet_load_paths, []),
      libs: Keyword.get(config, :libs, []),
      debug: Keyword.get(config, :debug, false)
    ]
  end

end
