defmodule Synex.Keys do
  @doc """
  Shorter syntax for common key-value definition idiom.

  It expands lists to keyword lists

      iex> name = "Synex"
      iex> version = 1
      iex> keys([name, version, test: true])
      [name: "Synex", version: 1, test: true]

      iex> keys([a,b,_]) = [a: 1, b: 2, c: 3]
      [a: 1, b: 2, c: 3]
      iex> {a, b}
      {1, 2}

      iex> range = fn keys([from, to, by]) ->
      ...>   from
      ...>   |> Stream.iterate(& &1 + by)
      ...>   |> Enum.take_while(& &1 <= to)
      ...> end
      iex> range.(from: 10, to: 30, by: 5)
      [10, 15, 20, 25, 30]

  And expand maps

      iex> name = "Jack"
      iex> age = 28
      iex> keys(%{name, age})
      %{age: 28, name: "Jack"}

      iex> keys(%{x, z}) = %{x: 10, y: 100, z: 1000}
      %{x: 10, y: 100, z: 1000}
      iex> {x, z}
      {10, 1000}

  `keys` also expand structs

      iex> keys(%Person{name, age}) = %Person{name: "John", age: 30}
      %Person{age: 30, languages: [], name: "John"}
      iex> age
      30
      iex> languages = [:elixir]
      iex> keys(%Person{name, languages, age: 29})
      %Person{age: 29, languages: [:elixir], name: "John"}

  can be used in update syntax

      iex> map = %{a: 1, b: 2, c: 3, d: 4}
      iex> {a, b} = {10, 20}
      iex> keys(%{map | a, b, c: 100, d: 200})
      %{a: 10, b: 20, c: 100, d: 200}

  you can pin values:

      iex> {a, b} = {1, 2}
      iex> keys(%{^a, ^b}) = %{a: 1, b: 2, c: 3}
      %{a: 1, b: 2, c: 3}
      iex> c = 10
      iex> keys(%{^a, ^c}) = %{a: 1, b: 2, c: 3}
      ** (MatchError) no match of right hand side value: %{a: 1, b: 2, c: 3}

  """
  defmacro keys(data), do: expand(data)

  defp expand({:%{}, meta, data}) do
    {:%{}, meta, expand(data)}
  end

  defp expand({:|, meta, [map, changes]}) do
    {:|, meta, [map, expand(changes)]}
  end

  defp expand({:%, meta, [struct, data]}) do
    {:%, meta, [struct, expand(data)]}
  end

  defp expand(data) when is_list(data) do
    Enum.map(data, &expand/1)
  end

  defp expand({:_, _, atom} = var) when is_atom(atom) do
    var
  end

  defp expand({name, _, atom} = var) when is_atom(atom) do
    {name, var}
  end

  defp expand({:^, _, [{name, _, atom}]} = pin) when is_atom(atom) do
    {name, pin}
  end

  defp expand(anything_else), do: anything_else
end
