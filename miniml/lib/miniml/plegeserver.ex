defmodule Servy.PledgeServer do

  @name :pledge_server
##the plage sends a message to the server, the srevers will  stock the  message in a memory cache
## pid = spawn (Servy.PledgeServer, :listen_loop, [[]])

  def start do
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def create_pledge(name, amount) do
    ## send the message to server to the server to create a pledge
    send @name, {self(), :create_pledge, name, amount}

    ## cache the plage in memory
    #[{"name", 10}]
    receive do {:response, status} -> status end
  end

  ## retunr the most rescent plege in the cache
  def recent_pledges do
    send @name, {self(), :recent_pledges}  ## send the message to get the recent message, the loop will return the recent plage

    receive do {:response, pledges} -> pledges end
  end

  def total_pledged do
    send @name, {self(), :total_pledged}

    receive do {:response, total} -> total end
  end

  # Server loop -------------------------------------
  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} -> IO.puts "Creating pledge for #{name} with amount #{amount}"
        {:ok, id} = send_pledge_to_service(name, amount)
        recent_pledges = Enum.take(state, 2)
        new_state = [ {name, amount} | recent_pledges ] ## updating the state cach memory
        send sender, {:response, id}
        listen_loop(new_state)  ##the servers can recievie n messages.
      {sender, :recent_pledges} ->## the sender is the pid of the  process that sent the message, so that xe can send back the  no mismatch
        send sender, {:response, state}## the list is not upadted
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    #send plege to external service
    {:ok, "pledg---------------#{:rand.uniform(1000)}"}
  end

end

alias Servy.PledgeServer

pid = PledgeServer.start()

send pid, {:stop, "hammertime"}

IO.inspect PledgeServer.create_pledge("larry", 10)
IO.inspect PledgeServer.create_pledge("moe", 20)
IO.inspect PledgeServer.create_pledge("curly", 30)

IO.inspect PledgeServer.recent_pledges()
IO.inspect  "%%%%%%%%%%%%%%%%%%%%%%%"

IO.inspect PledgeServer.total_pledged() ### the total is not implemented yet i need to add it to the server (loop function)
IO.inspect "********************"
IO.inspect Process.info(pid, :messages)
