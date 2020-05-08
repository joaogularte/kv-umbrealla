defmodule KV.Registry.Server do
  use GenServer

  def init(table) do
    names = :ets.new(table, [:named_table, read_concurrency: true])
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:names, :all}, _from, state) do
    {names, _} = state
    names_list = :ets.tab2list(names)
    {:reply, names_list, state}
  end

  def handle_call({:refs, :all}, _from, state) do
    {_, refs} = state
    {:reply, refs, state}
  end

  def handle_call({:create, name}, _from, {names, refs}) do
    case :ets.lookup(names, name) do
      [{^name, pid}] ->
        {:reply, pid, {names, refs}}

      [] ->
        {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        ref_monitor = Process.monitor(bucket)
        new_refs = Map.put(refs, ref_monitor, name)
        :ets.insert(names, {name, bucket})
        new_state = {names, new_refs}
        {:reply, bucket, new_state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
