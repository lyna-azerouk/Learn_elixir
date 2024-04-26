defmodule Servy.HttpServer2 do
  import :gen_tcp


  ## Starts a simple HTTP server on a specified port
def start(port) when is_integer(port) and port > 1023 do
  # Create a socket to listen for client connections on the specified port
  {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
  accept_loop(listen_socket)
end

defp accept_loop(listen_socket) do
  # Block until a client connects
  {:ok, client_socket} = :gen_tcp.accept(listen_socket)
  # use spawn to handle multiple connections
  ## we need to accept n connection in the same time
  spawn(fn ->receive_bis(client_socket) end )

  accept_loop(listen_socket)
end

##receive_bis will be run in separate process
defp receive_bis(client_socket) do
  # IO.puts( "*******************#{slelf()}")
  client_socket
  |> read_request()
  |> generate_response()
  |> write_response(client_socket)
end

defp read_request(client_socket) do
  {:ok, request} = :gen_tcp.recv(client_socket, 0)
  IO.puts("request: #{request}")
  request
end

defp generate_response(_request) do
  """
  HTTP/1.1 200 OK\r
  Content-Type: text/plain\r
  Content-Length: 12\r
  \r
  Hello World!
  """
end

defp write_response(response, client_socket) do
  :ok = :gen_tcp.send(client_socket, response)
  IO.inspect("response has been sent to the client")
  :ok = :gen_tcp.close(client_socket)
end

### eralng run a secular


end
