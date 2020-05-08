defmodule KV.Registry do
  ## Client API
  @doc """
  Start the registry with given options
  `:name` is must be informed
  """
  def start_link(opts) do
    server_name = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__.Server, server_name, opts)
  end

  @doc """
  Looks up the bucket for `name` stored in `server`
  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise
  """
  def lookup(server, name) do
    case :ets.lookup(server, name) do
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end

    # GenServer.call(server, {:lookup, name})
  end

  @doc """
  Returns all buckets stored in `server`
  """
  def all_buckets(server) do
    GenServer.call(server, {:names, :all})
  end

  @doc """
  Return all buckets refs
  """
  def all_refs(server) do
    GenServer.call(server, {:refs, :all})
  end

  @doc """
  Ensures there is a bucket associated with given `name` in `server`.
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
  end
end
