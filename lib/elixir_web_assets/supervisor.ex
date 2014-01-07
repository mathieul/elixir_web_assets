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
    libs = Mix.project[:elixir_web_assets][:libs]
    debug = Mix.project[:elixir_web_assets][:debug]

    [ libs:  (if libs == nil, do: [], else: libs),
      debug: (if debug == nil, do: false, else: debug) ]
  end

end
