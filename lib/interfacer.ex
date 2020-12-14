defmodule Interfacer do

  def start do
    {:ok, _server_pid} = PomoServer.start()
    reploop()
  end

  def reploop do
    IO.gets("\n(N) New • (P) ⏯️  Play/Pause • (Q) Quit\n> ")
    |> String.trim
    |> String.downcase
    |> process
  end

  def process("n") do
    PomoServer.new()
    reploop()
  end

  def process("p") do
    PomoServer.pauseplay()
    reploop()
  end

  def process("q") do
    PomoServer.stop()
    {:ok, "Bye!"}
  end

  def process(request) do
    IO.puts "I don't understand [#{request}]"
    reploop()
  end

end
