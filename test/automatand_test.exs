defmodule AutomatandTest do
  use ExUnit.Case
  doctest Automatand

  test "greets the world" do
    assert Automatand.hello() == :world
  end
end
