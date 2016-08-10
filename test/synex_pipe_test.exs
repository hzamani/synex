defmodule SynexPipeTest do
  use ExUnit.Case
  import Synex.{Pipe, Lambda}

  test "as list" do
    assert 14 = pipe(["this is a test", String.length])
    assert 4 = pipe(["this is a test", String.split, Enum.count])
  end

  test "as block" do
    assert 1 = pipe do: 1

    assert 14 = (
      pipe "this is a test"  do
        String.length
      end
    )

    assert 4 = (
      pipe "this is a test"  do
        String.split
        Enum.count
      end
    )

    assert "10,20,30,40,50" = (
      pipe 1..10 do
        Enum.filter f(rem(x, 2) == 0)
        Enum.map f(x * 5)
        Enum.join ","
      end
    )

    assert "10,20,30,40,50" = (
      pipe do
        1..10
        Enum.filter f(rem(x, 2) == 0)
        Enum.map f(x * 5)
        Enum.join ","
      end
    )
  end

  test "lambda in pipe" do
    assert 4 = pipe([1, f(x + 1), f(x * 2)])
  end
end
