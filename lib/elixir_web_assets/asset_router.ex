defmodule ElixirWebAssets.AssetRouter do

  use Dynamo.Router

  alias ElixirWebAssets.AssetPipeline

  get "/stylesheets/*" do
    content = AssetPipeline.stylesheet_content filename(conn)
    conn.resp 200, content
  end

  get "/javascripts/*" do
    bundle = !conn.params[:body]
    minify = !!conn.params[:min]
    content = AssetPipeline.script_content filename(conn), [bundle: bundle, minify: minify]
    conn.resp 200, content
  end

  defp filename conn do
    Enum.join conn.params[''], "/"
  end

end
