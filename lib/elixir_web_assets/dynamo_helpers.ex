defmodule ElixirWebAssets.Helpers do

  def stylesheet_link_tag(path, options // []) do
    full_path = asset_full_path path, ".css"
    if query = option_string options do
      full_path = Enum.join [ full_path, query ], "?"
    end
    %s[<link href="/assets/stylesheets/#{full_path}" media="all" rel="stylesheet" />]
  end

  def javascript_include_tag(path, options // []) do
    full_path = asset_full_path path, ".js"
    if Mix.env == :dev, do: options = Keyword.put(options, :bundle, true)
    if query = option_string options do
      full_path = Enum.join [ full_path, query ], "?"
    end
    %s[<script src="/assets/javascripts/#{full_path}"></script>]
  end

  defp asset_full_path(path, suffix) do
    if String.ends_with?(path, suffix) || String.contains?(path, ".") do
      path
    else
      path <> suffix
    end
  end

  defp option_string(options) do
    options |> Enum.map(&option_to_arg/1) |> Enum.reject(&nil?/1) |> Enum.join("&")
  end

  defp option_to_arg({ key, value }) when value do
    case key do
      :minify -> "min=1"
      :bundle -> "body=1"
      true -> nil
    end
  end
  defp option_to_arg(_), do: nil

end
