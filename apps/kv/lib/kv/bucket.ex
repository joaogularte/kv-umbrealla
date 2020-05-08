defmodule KV.Bucket do
  use Agent, restart: :temporary

  @moduledoc """
  Providers a group of function in order to manage the bucket
  """
  @doc """
  Start a new bucket
  """
  def start_link(opts) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Get a value from bucket by key
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Put the value for the given key in the bucket
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Remove the value for the given key in the bucket
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
