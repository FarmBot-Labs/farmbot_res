defmodule FarmbotRes.API.DownloadWoker do
  # use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  def init(args) do
    module = Keyword.fetch!(args, :module)
    function = Keyword.fetch!(args, :function)
    {:ok, %{module: module, function: function, task: nil}, 0}
  end

  def handle_info(:timeout, state) do
    task = Task.async(state.function)
    {:noreply, %{state | task: task}}
  end

  def handle_info({ref, data}, %{task: %{ref: ref}} = state) do
    {:noreply, %{state | task: nil}, {:continue, data}}
  end

  def handle_continue(%Ecto.Changeset{} = cs, state) do
    handle_changeset(cs, state)
  end

  def handle_continue([%Ecto.Changeset{} = cs | rest], state) do
    handle_changeset(cs, rest, state)
  end

  def handle_continue([], state) do
    {:stop, :normal, state}
  end

  def handle_changeset(%Ecto.Changeset{valid?: true} = cs, rest \\ [], state) do
    applied = Ecto.Changeset.apply_changes(cs)

    require IEx; IEx.pry
    case FarmbotRes.Repo.one(from d in state.module, where: d.id == applied.id) do
      nil -> applied
      old -> state.module.changeset(old)
    end
    {:noreply, state, {:continue, rest}}
  end

end
