defmodule Servy.HttpServer do
  import :gen_tcp

  ### Starts a simple HTTP server on a specified port
  def start(port) when is_integer(port) and port > 1023 do
    # Create a socket to listen for client connections on the specified port
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])
    accept_loop(listen_socket)
  end

  defp accept_loop(listen_socket) do
    IO.puts("accept loop")
    # Block until a client connects
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    # Process the client request
    receive_bis(client_socket)
    # Continue to accept more clients
    accept_loop(listen_socket)
  end

  defp receive_bis(client_socket) do
    client_socket
    |> read_request()
    |> Servy.HttpServer3.handle() ##traitement du message
    # |> generate_response()
    # |> write_response(client_socket)
  end

  defp read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    IO.puts("request: #{request}")
    request
  end

  # defp generate_response(_request) do
  #   """
  #   HTTP/1.1 200 OK\r
  #   Content-Type: text/plain\r
  #   Content-Length: 12\r
  #   \r
  #   Hello World!
  #   """
  # end

  # defp write_response(response, client_socket) do
  #   :ok = :gen_tcp.send(client_socket, response)
  #   IO.inspect("response has been sent to the client")
  #   :ok = :gen_tcp.close(client_socket)
  # end
end
