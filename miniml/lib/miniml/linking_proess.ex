defmodule Servy.KickStarter do

use GenServer
#server_pid = Process.whereis(:http_server) wth ===> runs in nother (pid process) logique on run un nouveau proess avec spawn
#Process.exit(server_pid, :sensors) ===> crash the server (:sensors) is the reason of the crash


def start_link(_arg) do  #for the supervisor only to link the topletvelsupervisor with this children
  IO.puts "Starting  children KickStarter"
  GenServer.start_link(__MODULE__, :ok, name: __MODULE__) ## la valeur avec laquelle est appeler init est :ok
end


def start do
  GenServer.start(__MODULE__, :ok, name: __MODULE__) ## la valeur avec laquelle est appeler init est :ok
end

def init(:ok) do
  Process.flag(:trap_exit, true) ## we want to trap the exit of the server , even if kickstart is linked to the server the kickstratserver  will still alive, WE CACH THE MESSAGE IN THE FUNCTION HANDELINFO

  IO.puts "Starting server with  porc 9000"
  server_pid = spawn( Servy.HttpServer, :start , [9000])  ## l eserveur tourne sur un autre pid que  kickstarter
  ## we need to now when the server crashes .
  # we can link too process together de manière bidirectionelle si un crash l'autre aussi
  Process.link(server_pid) ## if the server crashes the kickstarter will crash too

  Process.register(server_pid, :http_server)
  {:ok, server_pid}
end

# a chaque fois q'un serveru crash on va le redemarant sachant que la  fonction handall_info est apeller automatiquement via le Proces.flag
def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "Server crashed with reason: #{inspect reason}"
    ## let's start a new server
    server_pid = spawn( Servy.HttpServer, :start , [9000])  ## l eserveur tourne sur un autre pid que  kickstarter
    Process.register(server_pid, :http_server)
    server_pid
end



end
