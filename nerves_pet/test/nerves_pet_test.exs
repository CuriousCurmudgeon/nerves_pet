defmodule NervesPetTest do
  use ExUnit.Case
  doctest NervesPet

  test "greets the world" do
    assert NervesPet.hello() == :world
  end
end
