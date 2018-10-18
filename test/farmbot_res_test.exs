defmodule FarmbotResTest do
  use ExUnit.Case
  doctest FarmbotRes

  test "greets the world" do
    assert FarmbotRes.hello() == :world
  end
end
