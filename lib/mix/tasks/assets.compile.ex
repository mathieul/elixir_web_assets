defmodule Mix.Tasks.Assets.Compile do

  use Mix.Task

  alias ElixirWebAssets.StaticManifest
  alias ElixirWebAssets.AssetPipeline

  @shortdoc "Compile assets for production and generate manifest."
  @moduledoc "A task to compile assets"
  def run(_args) do
    ElixirWebAssets.Supervisor.start_link
    compile_javascripts config[:script_assets] || [ "application.js" ]
    compile_stylesheets config[:stylesheet_assets] || [ "application.css" ]
    StaticManifest.persist
    IO.puts "Assets compiled and manifest #{StaticManifest.manifest_path} generated."
  end

  defp config, do: Mix.project[:elixir_web_assets] || Keyword.new

  defp compile_javascripts assets do
    assets |> Enum.each fn name ->
      digest = AssetPipeline.script_digest_filename name
      unless digest == "" do
        content = AssetPipeline.script_content name, bundle: true#, minify: true
        StaticManifest.add_asset { name, digest, content }
      end
    end
  end

  defp compile_stylesheets assets do
    assets |> Enum.each fn name ->
      digest = AssetPipeline.stylesheet_digest_filename name
      unless digest == "" do
        content = AssetPipeline.stylesheet_content name, minify: true
        StaticManifest.add_asset { name, digest, content }
      end
    end
  end

end
