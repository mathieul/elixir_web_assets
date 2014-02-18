defmodule ElixirWebAssets.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [ worker(ElixirWebAssets.StaticManifest, []) ]
    if Mix.env == :dev, do: children = [ asset_pipeline_worker | children ]
    supervise(children, strategy: :one_for_one)
  end

  defp asset_pipeline_worker do
    worker ElixirWebAssets.AssetPipeline, [ asset_pipeline_config ]
  end

  defp asset_pipeline_config do
    [
      script_path: default_script_path,
      script_load_paths: default_script_load_paths,
      stylesheet_path: default_stylesheet_path,
      stylesheet_load_paths: default_stylesheet_load_paths,
      libs: Keyword.get(config, :libs, []),
      debug: Keyword.get(config, :debug, false)
    ]
  end

  defp config, do: Mix.project[:elixir_web_assets] || Keyword.new

  defp default_script_path do
    Keyword.get config, :script_path, Path.expand("assets/javascripts")
  end

  defp default_script_load_paths do
    Keyword.get config, :script_load_paths, [ Path.expand("bower_components") ]
  end

  defp default_stylesheet_path do
    Keyword.get config, :stylesheet_path, Path.expand("assets/stylesheets")
  end

  defp default_stylesheet_load_paths do
    Keyword.get config, :stylesheet_load_paths, []
  end

end
