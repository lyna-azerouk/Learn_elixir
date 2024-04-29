defmodule Servy.HttpServer3 do
  @moduledoc """
    Handles HTTP requests.
  """
  alias Servy.Conv
  alias Servy.Fetcher
  alias Servy.VideoCam
  import Servy.Parser

 def handle(request) do
  request
  |> parse
  |> route
end

  def route(%Conv{method: "GET", path: "/sensonrs"} = conv) do
    # IO.inspect("***********************")
    # ## Assunchron call to get_snapshot
    # pid1 = Fetcher.async(fn ->  VideoCam.get_snapshot("cam-1") end)
    # pid2 = Fetcher.async(fn ->  VideoCam.get_snapshot("cam-2") end)
    # pid3 = Fetcher.async(fn ->  VideoCam.get_snapshot("cam-2") end)
    # IO.inspect("***********************")

    # snapshot1 = Fetcher.get_result(pid1)
    # snapshot2 = Fetcher.get_result(pid2)
    # snapshot3 = Fetcher.get_result(pid3)
    # snapshots = [snapshot1, snapshot2, snapshot3]

    # ## comme ils sont assynchrone il peuvent ne pas arriver dans l'ordre
    # IO.inspect("snapshot1: #{inspect(snapshot1)}")
    # IO.inspect("snapshot2: #{inspect(snapshot2)}")
    # IO.inspect("snapshot3: #{inspect(snapshot3)}")

    #the list snapshots will not be in order
    ## to reconise a  function we  use it's pid

    # %{conv | status: 200, resp_body: inspect(snapshot1)}
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots = ##run in parallel the 3 calls
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)


    where_is_bigfoot = Task.await(task) ##wait for the result of the 1rs asynchronous call
    IO.inspect("snapshots: #{inspect(snapshots)}")
    IO.inspect("where_is_bigfoot: #{inspect(where_is_bigfoot)}")

    %{ conv | status: 200, resp_body: inspect {snapshots, where_is_bigfoot} }
  end

  ## the function route will be called when the request is a POST request and the path is /pledges
  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.get_sensor_data.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/sensors" } = conv) do
    sensor_data = Servy.SensorServer.get_sensor_data()

    %{ conv | status: 200, resp_body: inspect sensor_data }
  end

  def route(%Conv{ method: "GET", path: "/kaboom" }) do
    raise "Kaboom!"
  end


end
