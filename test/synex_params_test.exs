defmodule SynexParamsTest do
  use ExUnit.Case
  import Synex.Params

  test "expand map" do
    {name, age} = {"Jack", 26}
    assert %{"name" => "Jack", "age" => 26, "test" => true} =
      params(%{name, age, "test" => true})
  end

  test "expand map update" do
    person = %{"name" => "Jack", "age" => 26}
    name = "John"
    age = 28
    assert %{"name" => "John", "age" => 28} = params(%{person | name, age})
  end

  test "match map" do
    params(%{a, b}) = %{"a" => 1, "b" => 2, "c" => 3}
    assert {1, 2} = {a, b}
  end

  test "match map with pin" do
    a = 10
    b = 20
    params(%{^a, ^b, c}) = %{"a" => 10, "b" => 20, "c" => 30}
    assert 30 = c
  end

  test "nested maps" do
    params(%{a => %{b, c}}) = %{"a" => %{"b" => 2, "c" => 3}}
    assert {2, 3} = {b, c}
    assert %{"b" => 2, "c" => 3} = a
  end
end
