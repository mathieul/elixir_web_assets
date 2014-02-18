defmodule ElixirWebAssetsTest do

  use ExUnit.Case

  alias ElixirWebAssets.AssetPipeline

  setup_all  do
    AssetPipeline.set_script_path "test/fixtures/assets/javascripts"
    AssetPipeline.set_stylesheet_path "test/fixtures/assets/stylesheets"
    :ok
  end

  test "request static asset content in dev mode" do
    assert AssetPipeline.script_content("allo", []) == ~s{"ze content";\n}
  end

end
