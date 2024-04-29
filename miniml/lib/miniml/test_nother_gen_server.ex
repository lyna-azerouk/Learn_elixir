defmodule Servy.SensorServer do
### video nother gen server
  @name :sensor_server
  @refresh_interval :timer.minutes(60) #:timer.seconds(5) # :timer.minutes(60)

  use GenServer

  # Client Interface
  ### start thegen server
#*********  the handel_info function will update the cash when the init function makes a refersh

  def start do
    GenServer.start(__MODULE__, %{}, name: @name) ## start the gen server with the module name and the state {} but then the function init is called and the stat will change to init_state
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  def init(_state) do
    IO.puts "Initializing the cache"
    init_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, init_state}
  end

  def handel_info(:refresh, state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def handle_call(:get_sensor_data, _from, state) do ## when a call is made to the server with the function get_sensor_data the handle_call function is called
    {:reply, state, state} ## the server will reply with the state to the client
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp run_tasks_to_get_sensor_data do
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end



  ###Start_link function for supervisor
  def start_link(interval) do
    IO.puts "Starting SensorServer"
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end
end
