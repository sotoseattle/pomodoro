defmodule Super do
  use Supervisor

  def start_link do
    IO.puts "Starting supervisor"
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      PomoServer,
      ReplServer
    ]
    Supervisor.init(children, strategy: :one_for_all)
  end
end
