defmodule ReplServer do
  @name :repl_server
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, {:ok, reploop(:ok)}, name: @name)
  end

  def init(state), do: state

  def reploop(:out), do: System.stop(0)

  def reploop(:ok) do
    IO.gets("\n(N) New • (P) ⏯️  Play/Pause • (Q) Quit\n> ")
    |> String.trim
    |> String.downcase
    |> process
    |> reploop
  end

  def process("n") do
    PomoServer.new()
    :ok
  end

  def process("p") do
    PomoServer.pauseplay()
    :ok
  end

  def process("q"), do: :out

  def process(request) do
    IO.puts "I don't understand [#{request}]"
    :ok
  end

end
