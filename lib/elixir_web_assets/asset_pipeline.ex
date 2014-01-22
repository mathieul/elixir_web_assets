defmodule ElixirWebAssets.AssetPipeline do

  use ExActor, export: :asset_pipeline

  alias ElixirWebAssets.CommandWrapper

  defrecordp :state_rec, received: [], port: nil

  definit options do
    port = CommandWrapper.start options
    state_rec port: port
  end

  defcall set_script_path(path), state: state do
    state_rec(port: port) = state
    case CommandWrapper.set_script_path(port, path) do
      :ok   -> set_and_reply state, :ok
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall set_stylesheet_path(path), state: state do
    state_rec(port: port) = state
    case CommandWrapper.set_stylesheet_path(port, path) do
      :ok   -> set_and_reply state, :ok
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall add_script_load_path(path), state: state do
    state_rec(port: port) = state
    case CommandWrapper.add_script_load_path(port, path) do
      :ok   -> set_and_reply state, :ok
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall add_stylesheet_load_path(path), state: state do
    state_rec(port: port) = state
    case CommandWrapper.add_stylesheet_load_path(port, path) do
      :ok   -> set_and_reply state, :ok
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall script_filenames(filename), state: state do
    state_rec(port: port) = state
    case CommandWrapper.script_filenames(port, filename) do
      { :filenames, filenames } -> set_and_reply state, tuple_to_list(filenames)
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall script_digest_filename(filename), state: state do
    state_rec(port: port) = state
    case CommandWrapper.script_digest_filename(port, filename) do
      { :filename, filename } -> set_and_reply state, filename
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall script_content(filename, options), state: state do
    state_rec(port: port) = state
    case CommandWrapper.script_content(port, filename, options) do
      { :content, content } -> set_and_reply state, content
      error -> set_and_reply state, { :error, error }
    end
  end
  def script_content(filename), do: script_content(filename, [])

  defcall stylesheet_digest_filename(filename), state: state do
    state_rec(port: port) = state
    case CommandWrapper.stylesheet_digest_filename(port, filename) do
      { :filename, filename } -> set_and_reply state, filename
      error -> set_and_reply state, { :error, error }
    end
  end

  defcall stylesheet_content(filename, options), state: state do
    state_rec(port: port) = state
    case CommandWrapper.stylesheet_content(port, filename, options) do
      { :content, content } -> set_and_reply state, content
      error -> set_and_reply state, { :error, error }
    end
  end
  def stylesheet_content(filename), do: stylesheet_content(filename, [])

  defcast stop, state: state do
    { :stop, :normal, state }
  end

  def terminate(_reason, state_rec(port: port)) do
    CommandWrapper.stop port
    :ok
  end

end
