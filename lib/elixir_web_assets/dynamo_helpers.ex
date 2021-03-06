defmodule ElixirWebAssets.Helpers do

  alias ElixirWebAssets.AssetPipeline
  alias ElixirWebAssets.StaticManifest

  def stylesheet_link_tag path, options \\ [] do
    full_path = asset_full_path path, ".css"
    if Mix.env == :dev do
      dev_stylesheet_link_tag full_path, options
    else
      digest = StaticManifest.name_to_digest full_path
      ~s[<link href="/assets/css/#{digest || path}" media="all" rel="stylesheet" />]
    end
  end

  def dev_stylesheet_link_tag path, options do
    if query = option_string options do
      path = Enum.join [ path, query ], "?"
    end
    ~s[<link href="/assets/stylesheets/#{path}" media="all" rel="stylesheet" />]
  end

  def javascript_include_tag path, options \\ [] do
    if Mix.env == :dev do
      dev_javascript_include_tag path, options
    else
      full_path = asset_full_path path, ".js"
      digest = StaticManifest.name_to_digest full_path
      ~s[<script src="/assets/js/#{digest || path}"></script>]
    end
  end

  defp dev_javascript_include_tag path, options do
    if nil? options[:bundle] do
      options = Keyword.put(options, :bundle, false)
    end

    script_files_for(path, options[:bundle])
      |> Enum.map(fn file -> full_path_and_query(file, options) end)
      |> Enum.map(&(~s[<script src="/assets/javascripts/#{&1}"></script>]))
      |> Enum.join("\n")
  end

  defp asset_full_path(path, suffix) do
    if String.ends_with?(path, suffix) do
      path
    else
      path <> suffix
    end
  end

  defp script_files_for(path, bundle) do
    if bundle, do: [path], else: AssetPipeline.script_filenames(path)
  end

  def full_path_and_query(path, options) do
    full_path = asset_full_path path, ".js"
    if query = option_string options do
      full_path = Enum.join [ full_path, query ], "?"
    end
    full_path
  end

  defp option_string(options) do
    unless options[:bundle], do: options = Keyword.put(options, :no_bundle, true)
    options |> Enum.map(&option_to_arg/1) |> Enum.reject(&nil?/1) |> Enum.join("&")
  end

  defp option_to_arg({ key, value }) when value do
    case key do
      :minify -> "min=1"
      :no_bundle -> "body=1"
      _ -> nil
    end
  end
  defp option_to_arg(_), do: nil

end
