defmodule ElixirWebAssets.AssetPipeline do

  use ExActor, export: :asset_pipeline

  alias ElixirWebAssets.CommandWrapper

  defrecordp :state_rec, received: [], port: nil

  definit options do
    paths = %W[assets bower_components] |> Enum.map fn path ->
      Path.expand path, File.cwd!
    end
    port = Keyword.merge(options, [ paths: paths ]) |> CommandWrapper.start
    state_rec port: port
  end

  defcall append_path(path), state: state do
    case CommandWrapper.append_paths(state_rec(state, :port), [ path ]) do
      :ok -> set_and_reply state, :ok
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall get_files(path), state: state do
    case CommandWrapper.get_files(state_rec(state, :port), path) do
      { :files, files } -> set_and_reply state, tuple_to_list(files)
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall render_file(path), state: state do
    case CommandWrapper.render_file(state_rec(state, :port), path) do
      { :content, content } -> set_and_reply state, content
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall render_bundle(path), state: state do
    case CommandWrapper.render_bundle(state_rec(state, :port), path) do
      { :content, content } -> set_and_reply state, content
      error -> set_and_reply state, { :error, error }
    end
  end

  defcast stop, state: state do
    { :stop, :normal, state }
  end

  def terminate(_reason, state) do
    CommandWrapper.stop state_rec(state, :port)
    :ok
  end

end
