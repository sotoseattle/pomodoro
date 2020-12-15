defmodule PomoServer do
  @name :pomo_server

  use GenServer

  defmodule State do
    @basis 20
    defstruct remaining: @basis, ticking: nil

    def new, do: %__MODULE__{}
    def basis, do: @basis
  end

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting the Pomodoro server"
    GenServer.start_link(__MODULE__, State.new(), name: @name)
  end

  def new, do: GenServer.cast(@name, :new)
  def pauseplay, do: GenServer.cast(@name, :pauseplay)

  # Server Callbacks

  def init(state), do: {:ok, state}

  def handle_cast(:new, state) do
    log "starting pomodoro countdown..."
    new_state = state
    |> Map.put(:remaining, State.basis())
    |> tick
    {:noreply, new_state}
  end

  def handle_cast(:pauseplay, %State{ ticking: nil } = state) do
    log "... continuing countdown ..."
    {:noreply, tick(state)}
  end

  def handle_cast(:pauseplay, %State{ ticking: timer } = state) do
    log "... pausing countdown ..."
    cancel_msg(timer)
    {:noreply, %State{ state | ticking: nil }}
  end

  def handle_info(:tock, %State{ remaining: 0} = state) do
    log "Tuto sei finitoooooo"
    cancel_msg(state.ticking)
    {:noreply, %State{ state | ticking: nil }}
  end

  def handle_info(:tock, %State{ remaining: secs} = state) do
    tomatina_bar(secs-1)
    new_state = state
    |> Map.put(:remaining, secs - 1)
    |> tick
    {:noreply, new_state}
  end

  defp tick(%State{ ticking: timer } = state) do
    cancel_msg(timer)
    Map.put(
      state,
      :ticking,
      Process.send_after(self(), :tock, :timer.seconds(1)))
  end

  defp cancel_msg(nil), do: :ok
  defp cancel_msg(ref), do: Process.cancel_timer(ref)

  defp log(msg), do: IO.puts(msg)

  defp tomatina_bar(secs) do
    IO.puts("\e[H\e[2J")

    "🟩"
    |> String.duplicate(State.basis - secs)
    |> String.pad_trailing(State.basis, "⬜")
    |> IO.puts
  end
end
