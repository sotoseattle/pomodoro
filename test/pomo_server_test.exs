defmodule PomoServerTest do
  use ExUnit.Case
  # doctest Pomodoro

  test "greets the world" do
    {:ok, pid} = PomoServer.start()

    PomoServer.countdown()
    :timer.seconds(10)

    assert PomoServer.hello() == :world
  end
end
