defmodule ElixirWebAssets.Helpers do

  def stylesheet_link_tag(path) do
    full_path = asset_full_path path, ".css"
    %s[<link href="/assets/stylesheets/#{full_path}" media="all" rel="stylesheet" />]
  end

  def javascript_include_tag(path) do
    full_path = asset_full_path path, ".js"
    render_asset_tag full_path, Mix.env, fn file, extra ->
      %s[<script src="/assets/javascripts/#{file}#{extra}"></script>]
    end
  end

  defp render_asset_tag(path, env, renderer) when env == :dev do
    ElixirWebAssets.AssetPipeline.script_filenames(path)
      |> Enum.map(&(renderer.(&1, "?body=1")))
      |> Enum.join("\n")
  end
  defp render_asset_tag(path, renderer), do: renderer.(path, "")

  defp asset_full_path(path, suffix) do
    if String.ends_with?(path, suffix) || String.contains?(path, ".") do
      path
    else
      path <> suffix
    end
  end

end
