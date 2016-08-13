defmodule Synex.Params do
  @doc """
  Shorter syntax for common map key-value definition idiom.

      iex> {name, age} = {"Jack", 26}
      iex> params(%{name, age, "test" => true})
      %{"name" => "Jack", "age" => 26, "test" => true}

      iex> person = %{"name" => "Jack", "age" => 26}
      iex> name = "John"
      iex> params(%{person | name, "age" => 28})
      %{"name" => "John", "age" => 28}

      iex> params(%{a, b}) = %{"a" => 1, "b" => 2, "c" => 3}
      iex> {a, b}
      {1, 2}

      iex> {a, b} = {10, 20}
      iex> params(%{^a, ^b, c}) = %{"a" => 10, "b" => 20, "c" => 30}
      iex> c
      30
      iex> params(%{^a}) = %{"a" => "bad"}
      ** (MatchError) no match of right hand side value: %{"a" => "bad"}

  It expands nested maps:

      iex> params(%{a => %{b, c}}) = %{"a" => %{"b" => 2, "c" => 3}}
      iex> {b, c}
      {2, 3}
      iex> a
      %{"b" => 2, "c" => 3}

  """
  defmacro params(data), do: expand(data)

  defp expand({:%{}, meta, data}) do
    {:%{}, meta, expand(data)}
  end

  defp expand({:|, meta, [map, changes]}) do
    {:|, meta, [map, expand(changes)]}
  end

  defp expand(data) when is_list(data) do
    Enum.map(data, &expand/1)
  end

  defp expand({name, _, atom} = var) when is_atom(atom) do
    {Atom.to_string(name), var}
  end

  defp expand({{name, meta, atom} = key, value}) when is_atom(atom) do
    {Atom.to_string(name), {:=, meta, [key, expand(value)]}}
  end

  defp expand({:^, _, [{name, _, atom}]} = pin) when is_atom(atom) do
    {Atom.to_string(name), pin}
  end

  defp expand({key, value}) do
    {key, expand(value)}
  end

  defp expand(anything_else), do: anything_else
end
