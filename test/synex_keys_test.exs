defmodule SynexKeysTest do
  use ExUnit.Case
  import Synex.Keys

  defmodule Person do
    defstruct name: "", age: 10, languages: []
  end

  test "expand map update" do
    person = %{name: "Jack", age: 27}
    name = "John"
    age = 28
    assert %{name: "John", age: 28} = keys(%{person | name, age})
  end

  test "expand struct" do
    {name, age} = {"Jack", 26}
    assert %Person{name: "Jack", age: 26, languages: [:elixir]} =
      keys(%Person{name, age, languages: [:elixir]})
  end

  test "expand keyword" do
    {name, age} = {"Jack", 26}
    assert [name: "Jack", age: 26, test: true] = keys([name, age, test: true])
  end

  test "match map" do
    keys(%{a, b}) = %{a: 1, b: 2, c: 3}
    assert {1, 2} = {a, b}
  end

  test "match pined map" do
    {a, b} = {1, 2}
    assert keys(%{^a, ^b}) = %{a: 1, b: 2, c: 3}
  end

  test "match keyword" do
    keys([a, b, _]) = [a: 1, b: 2, c: 3]
    assert {1, 2} = {a, b}
  end

  test "match struct" do
    assert keys(%Person{name, age}) = %Person{name: "Jack", age: 26}
    assert {"Jack", 26} = {name, age}
  end

  test "nested" do
    keys(%{a: [b, c: %{d}]}) = %{a: [b: 1, c: %{d: 2}]}
    assert 1 = b
    assert 2 = d
    assert keys(%{a: [^b, c: %{^d}]}) = %{a: [b: 1, c: %{d: 2}]}
  end
end
