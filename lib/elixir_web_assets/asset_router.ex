defmodule ElixirWebAssets.AssetRouter do

  use Dynamo.Router

  alias ElixirWebAssets.AssetPipeline
  alias ElixirWebAssets.StaticManifest

  prepare do
    conn.fetch [:params]
  end

  get "/stylesheets/*" do
    content = AssetPipeline.stylesheet_content filename(conn), []
    conn.resp_content_type("text/css").resp 200, content
  end

  get "/css/*" do
    content = StaticManifest.digest_to_content filename(conn)
    conn.resp_content_type("text/css").resp 200, content
  end

  get "/javascripts/*" do
    options = [bundle: !conn.params[:body], minify: !!conn.params[:min]]
    content = AssetPipeline.script_content filename(conn), options
    conn.resp_content_type("application/javascript").resp 200, content
  end

  get "/js/*" do
    content = StaticManifest.digest_to_content filename(conn)
    conn.resp_content_type("application/javascript").resp 200, content
  end

  defp filename conn do
    Enum.join conn.params[''], "/"
  end

end
