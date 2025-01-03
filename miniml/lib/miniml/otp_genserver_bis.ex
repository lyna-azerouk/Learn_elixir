defmodule Servy.PledgeServerBis do

  @name :pledge_server

  use GenServer


  defmodule State do  #define new struct
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface
  def start do
    IO.puts "Starting the pledge server..."
    GenServer.start(__MODULE__, %State{}, name: @name)  ### define the init function to define the  state (init is called automaticly)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do
    GenServer.cast @name, :clear
  end


  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server Callbacks
  def init (state) do
    {:ok,  %{state | pledges: fetch_recent_pledges_from_service()}}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{ state | pledges: []}}
  end
  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{ state | cache_size: size}}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}  ## we add reply because of the genserver
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [ {name, amount} | most_recent_pledges ]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end


  def handle_info(message, state) do
    IO.puts "Can't touch this! #{inspect message}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    [ {"wilma", 15}, {"fred", 25} ]
  end
end

alias Servy.PledgeServerBis

{:ok, pid} = PledgeServerBis.start()  ##no error hier it 's ok

send pid, {:stop, "hammertime"}

IO.inspect PledgeServerBis.create_pledge("FIRST PLEGE", 10)
 IO.inspect PledgeServerBis.recent_pledges() #the result is: [{"FIRST PLEGE", 10}, {"wilma", 15}, {"fred", 25}] where   {"wilma", 15}, {"fred", 25} commes from init and {"FIRST PLEGE", 10} comme from :create_peldge

# IO.inspect PledgeServerBis.total_pledged()
