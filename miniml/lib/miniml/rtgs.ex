defmodule Servy.GenServer do

  def start(initial_state, name) do
    IO.puts "Starting the pledge server..."
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid,  name)
    pid
  end

  def call(server_pid, message) do
    send server_pid, {:call, self(), message}
    receive do
      {:response, value} ->value
    end
  end

  def cast(pid, message) do
      send pid, {:cast, message}
  end

  def listen_loop (state) do
    receive do
      {:call, sender,  message} when is_pid(sender)->
        {response, new_state} =   Servy.PledgeServer.handle_call(message, state) ## generic ffunction to intersept all messages
        send sender, {:response, response}  ## send back to the client
        listen_loop(new_state)
      {:cast,  message}  -> ## untill the server can recive asynchron messages that can be send by the client we dont neet the pid_sender becaus ewe will not send back a respoonse
        new_state = Servy.PledgeServer.handle_cast(message, state)  ## sont send back a response to the client
        listen_loop(new_state)
      unexpected_message ->
        IO.puts "Unexpected message: #{inspect unexpected_message}"
        listen_loop(state)
    end
  end
end


defmodule Servy.PledgeServer do
  @name :pledge_server

  alias Servy.GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface

  def start do
    GenServer.start(%State{}, @name)
  end


  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  @spec total_pledged() :: any()
  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do### asynchron  don't wait for a respons
  GenServer.cast @name, :clear
    receive do
      {:response, response} -> response
    end
  end



  ###****************************************************************$$
   # Server Callbacks

  def handle_call(:total_pledged, state) do  ## for evry specific message
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [ {name, amount} | most_recent_pledges ]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  @spec init(%{:pledges => any(), optional(any()) => any()}) ::
          {:ok, %{:pledges => [{any(), any()}, ...], optional(any()) => any()}}
  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
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
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [ {"wilma", 15}, {"fred", 25} ]
  end
end
