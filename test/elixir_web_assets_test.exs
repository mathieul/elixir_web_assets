defmodule ElixirWebAssetsTest do

  use ExUnit.Case

  alias ElixirWebAssets.AssetPipeline

  setup_all  do
    AssetPipeline.append_path "test/fixtures/assets"
    :ok
  end

  test "request static asset content in dev mode" do
    assert AssetPipeline.render_bundle("javascripts/allo.js") == %s{"ze content";}
  end

end
