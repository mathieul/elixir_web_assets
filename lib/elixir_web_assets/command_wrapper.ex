defmodule ElixirWebAssets.CommandWrapper do

  def start(options // []) do
    port = open_port build_command(options)
    set_script_path port, Keyword.fetch!(options, :script_path)
    set_stylesheet_path port, Keyword.fetch!(options, :stylesheet_path)
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
    Port.open { :spawn, cmd }, [
      { :packet, 4 },
        :use_stdio,
        :exit_status,
        :binary
      ]
  end

  def stop(port), do: Port.close(port)

  def set_script_path(port, path), do: exec_request(port, { :set_script_path, path })

  def set_stylesheet_path(port, path), do: exec_request(port, { :set_stylesheet_path, path })

  def append_javascript_path(port, path), do: exec_request(port, { :append_javascript_path, path })

  def append_stylesheet_path(port, path), do: exec_request(port, { :append_stylesheet_path, path })

  def get_files(port, path), do: exec_request(port, { :get_files, path })

  def render_file(port, path), do: exec_request(port, { :render_file, path })

  def render_bundle(port, path), do: exec_request(port, { :render_bundle, path })

  defp exec_request(port, request) do
    payload = Kernel.term_to_binary(request)
    Port.command(port, payload)
    receive do
      { ^port, { :data, data } } -> binary_to_term(data)
    end
  end

end
