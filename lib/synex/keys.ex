defmodule Synex.Keys do
  @moduledoc """
  A set of function to work with keyword lists,
  that is 2-item tuples where the first item is an atom.
  """

  import Synex.Lambda
  import Synex.Pipe

  @doc """
  Expands varius structions to keyword lists.

  It expands lists to keyword lists

    iex> name = "Synex"
    iex> version = 1
    iex> keys([name, version, test: true])
    [name: "Synex", version: 1, test: true]

    iex> keys([a,b,_]) = [a: 1, b: 2, c: 3]
    [a: 1, b: 2, c: 3]
    iex> {a, b}
    {1, 2}

  And expand maps

    iex> name = "Jack"
    iex> age = 28
    iex> keys(%{name, age})
    %{age: 28, name: "Jack"}

    iex> keys(%{x, z}) = %{x: 10, y: 100, z: 1000}
    %{x: 10, y: 100, z: 1000}
    iex> {x, z}
    {10, 1000}

  Also for structs

    iex> defmodule Person do
    ...>   defstruct [:name, :age, :languages]
    ...> end
    1
    iex> keys(%Person{name, age}) = %Person{name: "John", age: 30}
    1

  """
  defmacro keys(data), do: expand(data)

  defp expand({:%{}, meta, data}) do
    pipe data do
      expand
      f({:%{}, meta, x})
    end
  end

  defp expand({:|, meta, [map, changes]}) do
    pipe changes do
      expand
      f({:|, meta, [map, x]})
    end
  end

  defp expand({:%, meta, [struct, data]}) do
    pipe data do
      expand
      f({:%, meta, [struct, x]})
    end
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

  defp expand({key, value}) do
    {key, expand(value)}
  end

  defp expand(anything_else), do: anything_else
end
