defmodule Servy.ServicesSupervisor do
  #{:ok, pid}= Servy.ServicesSupervisor.start_link()
  ## we need to specify the first chld_process_list to start with
  #Supervisor.which_children(pid)
  #Servy.ServicesSupervisor.child_spec([])
  # %{
#   id: Servy.ToplevelSupervisor,
#   start: {Servy.ToplevelSupervisor, :start_link, [[]]},
#   type: :worker
# }

  use Supervisor

  def start_link(_arg) do  ##we add the arg for the supervisor only
    ##  start the supervisor prosess and links it to the server that calls the start function
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [  ## start the children process
      {Servy.SensorServer, 60}  ##60 is the refresh interval
    ]

    #one_for_one ==>
    Supervisor.init(children, strategy: :one_for_one)
  end

end
