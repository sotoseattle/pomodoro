defmodule Pomodoro do

  use Application

  def start(_type, _args) do
    IO.puts "Starting application..."
    Super.start_link()
  end
end
