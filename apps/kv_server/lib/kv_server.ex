defmodule KVServer do
  @moduledoc """
  Documentation for `KVServer`.
  """

  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, &serve(client)
    
    serve(client)
    loop_acceptor(socket)
  end

  def serve(socket) do
    socket
    |> read_line()
    |> write_line(socket)

    serve(socket)
  end

  def read_line(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, msg} -> msg
      {:error, error} -> error
    end
  end

  def write_line(msg, socket) do
    case :gen_tcp.send(socket, msg) do
      :ok -> :ok
      {:error, error} -> {:error, error}
    end
  end
end
