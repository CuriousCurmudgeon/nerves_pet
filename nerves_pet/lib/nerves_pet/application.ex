defmodule NervesPet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        # Children for all targets
        # Starts a worker by calling: NervesPet.Worker.start_link(arg)
        # {NervesPet.Worker, arg},
      ] ++ target_children()

    prepare_system(target())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesPet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def prepare_system(:host) do
  end

  def prepare_system(_target) do
    File.makdir_p("/var/run/lirc")
  end

  # List all child processes to be supervised
  if Mix.target() == :host do
    defp target_children() do
      [
        # Children that only run on the host during development or test.
        # In general, prefer using `config/host.exs` for differences.
        #
        # Starts a worker by calling: Host.Worker.start_link(arg)
        # {Host.Worker, arg},

        # Does this even need the --nodaemon flag if we set it in lirc_options.conf instead?
        {MuonTrap.Daemon, ["lircd", ["--nodaemon"]]}
      ]
    end
  else
    defp target_children() do
      [
        # Children for all targets except host
        # Starts a worker by calling: Target.Worker.start_link(arg)
        # {Target.Worker, arg},
      ]
    end
  end
end
