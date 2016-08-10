defmodule SynexTest do
  use ExUnit.Case
  use Synex

  defmodule Person do
    defstruct name: "", age: 10, languages: []
  end

  doctest Synex.Lambda
  doctest Synex.Keys

  def range(keys([from, to, by])) do
    pipe from do
      Stream.iterate f(x + by)
      Enum.take_while f(x <= to)
    end
  end

  test "range" do
    assert [10, 15, 20, 25, 30] = range(from: 10, to: 30, by: 5)
  end
end
