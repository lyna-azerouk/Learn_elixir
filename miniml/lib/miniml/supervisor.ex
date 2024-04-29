defmodule Servy.ToplevelSupervisor do
  use Supervisor
## the super super super supervisor
# {:ok, pid} = Servy.ToplevelSupervisor.start_link()
#Servy.ToplevelSupervisorchild_spec([]) the type in this case is :supervisor
# %{
#   id: Servy.ToplevelSupervisor,
#   start: {Servy.ToplevelSupervisor, :start_link, [[]]},
#   type: :supervisor
# }

## kil a supervisor: Process.exit(pid, :kill) oh hien!!!!!!!!!!!!!!!!!!!

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.KickStarter, ##updates are made on KickStarter and the ServicesSupervisor
      Servy.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
