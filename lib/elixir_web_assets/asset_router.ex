defmodule ElixirWebAssets.AssetRouter do

  use Dynamo.Router

  get "/:type/*" when type in %W[stylesheets javascripts] do
    path = [ conn.params[:type] ] ++ conn.params[''] |> Enum.join "/"
    conn.resp 200, content(path, conn.params[:body])
  end

  defp content(filename, body) do
    if body do
      ElixirWebAssets.AssetPipeline.script_content filename, []
    else
      ElixirWebAssets.AssetPipeline.render_bundle filename, [bundle: true]
    end
  end

end
