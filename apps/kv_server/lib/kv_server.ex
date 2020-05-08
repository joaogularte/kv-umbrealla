defmodule KVServer do
  @moduledoc """
  Documentation for `KVServer`.
  """

  require Logger
  def accept(port)

  {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

  Logger.info("Accepting connections on port #{port}")

  end

  def loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
  end

  def serve(socket) do
  socket
  end
end
