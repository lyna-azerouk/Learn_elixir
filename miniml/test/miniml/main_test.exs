defmodule Miniml.MainTest do
  use ExUnit.Case
  doctest Miniml.Main

  test "greets the world" do
    assert Miniml.Main.hello() == :world
  end
end
