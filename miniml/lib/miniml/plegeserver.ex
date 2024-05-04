defmodule Servy.PledgeServerGen do    #Importnat


  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server Callbacks

  def init(state) do ## this function is called when the server is started
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state} ### initialisation wtf
  end

  def handle_cast(:clear, state) do
    {:noreply, %{ state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{ state | cache_size: size}
    {:noreply, new_state}
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

  def handle_info(_message, state) do
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do

    [ {"*******", 15} ]
  end

end

alias Servy.PledgeServerGen

{:ok, pid} = PledgeServerGen.start()

send pid, {:stop, "hammertime"}

PledgeServerGen.set_cache_size(4)

IO.inspect PledgeServerGen.create_pledge("$$$$$$$$$$", 10)

# PledgeServer.clear()

IO.inspect PledgeServerGen.create_pledge("€€€€€€€€€€€€€€€€€", 20)

IO.inspect PledgeServerGen.recent_pledges()
