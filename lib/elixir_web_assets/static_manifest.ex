defmodule ElixirWebAssets.StaticManifest do

  use ExActor.Tolerant, export: :static_manifest

  defrecord AssetManifest, by_digest: HashDict.new, by_name: HashDict.new

  definit do: initial_state(load_manifest)

  defcast reset do
    new_state AssetManifest.new
  end

  defcast persist, state: manifest do
    File.write! manifest_path, :erlang.term_to_binary(manifest)
    noreply
  end

  defcast add_asset({ name, digest, content }), state: manifest do
    AssetManifest[by_digest: by_digest, by_name: by_name] = manifest
    by_name = Dict.put by_name, name, digest
    by_digest = Dict.put by_digest, digest, content
    new_state AssetManifest.new(by_digest: by_digest, by_name: by_name)
  end

  defcall name_to_digest(name), state: AssetManifest[by_name: by_name] do
    reply by_name[name]
  end

  defcall digest_to_content(digest), state: AssetManifest[by_digest: by_digest] do
    reply by_digest[digest]
  end

  defcast stop, state: state do
    { :stop, :normal, state }
  end

  def terminate _reason, _state do
    :ok
  end

  defp load_manifest do
    case File.read manifest_path do
      { :ok, content } -> :erlang.binary_to_term content
      { :error, _ }    -> AssetManifest.new
    end
  end

  def static_path,   do: Path.expand "./priv/static"
  def manifest_path, do: Path.expand "./priv/manifest.data"

end
