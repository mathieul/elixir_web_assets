defmodule Mix.Tasks.Assets.Setup do

  use Mix.Task

  @template_path Path.expand('../../../templates', __DIR__)

  @shortdoc "Setup elixir_web_assets in the current Elixir project"
  @moduledoc "A task to setup elixir_web_assets"
  def run(_args) do
    setup_bundler
    setup_folders
  end

  defp setup_bundler do
    Mix.shell.info "Setup Bundler."
    ~W[Gemfile Gemfile.lock] |> Enum.each fn name ->
      File.cp "#{@template_path}/#{name}", name, ask_for_confirmation
    end
    Mix.shell.cmd "bundle install"
  end

  defp setup_folders do
    Mix.shell.info "Create folders."
    ~w[assets/javascripts assets/stylesheets bower_components] |> Enum.each fn name ->
      File.mkdir_p! name
    end
    ~W[javascripts/application.js stylesheets/application.scss] |> Enum.each fn path ->
      File.cp "#{@template_path}/#{path}", "assets/#{path}", ask_for_confirmation
    end
  end

  defp ask_for_confirmation do
    fn destination, source ->
      IO.gets("Overwriting #{destination} by #{source}. Type y to confirm.") == "y"
    end
  end

end
