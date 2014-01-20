defmodule ElixirWebAssets.CommandWrapper do

  def start(options // []) do
    port = open_port build_command(options)
    set_script_path port, Keyword.fetch!(options, :script_path)
    Keyword.fetch!(options, :script_load_paths) |> Enum.each fn path ->
      add_script_load_path port, path
    end
    set_stylesheet_path port, Keyword.fetch!(options, :stylesheet_path)
    Keyword.fetch!(options, :stylesheet_load_paths) |> Enum.each fn path ->
      add_stylesheet_load_path port, path
    end
    port
  end

  defp build_command(options) do
    libs = Keyword.get(options, :libs, [])
      |> Enum.map(&('--require #{&1}'))
      |> Enum.join(" ")
      |> bitstring_to_list

    cmd = Keyword.get options, :command
    if nil?(cmd), do: cmd = 'bundle exec web_assets.rb'
    if Keyword.get(options, :debug, false), do: cmd = '#{cmd} --debug'
    cmd = if is_bitstring(cmd), do: bitstring_to_list(cmd), else: cmd
    unless Enum.empty?(libs), do: cmd = cmd ++ ' ' ++ libs
    cmd
  end

  defp open_port(cmd) do
    Port.open { :spawn, cmd }, [ { :packet, 4 }, :exit_status, :binary ]
  end

  def stop(port), do: Port.close(port)

  def set_script_path(port, path) do
    exec_request port, { :set_script_path, path }
  end

  def set_stylesheet_path(port, path) do
    exec_request port, { :set_stylesheet_path, path }
  end

  def add_script_load_path(port, path) do
    exec_request port, { :add_script_load_path, path }
  end

  def add_stylesheet_load_path(port, path) do
    exec_request port, { :add_stylesheet_load_path, path }
  end

  def script_filenames(port, filename) do
    exec_request port, { :script_filenames, filename }
  end

  def script_digest_filename(port, filename) do
    exec_request port, { :script_digest_filename, filename }
  end

  def script_content(port, filename, options) do
    exec_request port, { :script_content, [ filename, options ] }
  end

  def stylesheet_digest_filename(port, filename) do
    exec_request port, { :stylesheet_digest_filename, filename }
  end

  def stylesheet_content(port, filename, options) do
    exec_request port, { :stylesheet_content, [ filename, options ] }
  end

  defp exec_request(port, request) do
    payload = :erlang.term_to_binary request
    Port.command port, payload
    receive do
      { ^port, { :data, data } } -> :erlang.binary_to_term data
    end
  end

end
