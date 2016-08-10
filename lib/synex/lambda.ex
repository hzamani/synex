defmodule Synex.Lambda do
  @doc """
  Defines an anonymous function.
  Last parameter is the function body and others are it's parameters.

  ## Examples

      iex> f(n, n * 100).(2)
      200

      iex> add = f(a, b, a + b)
      iex> add.(1, 2)
      3

      iex> tail = f([_|t], t)
      iex> tail.([1,2,3,4])
      [2, 3, 4]

      iex> f(a, b, c, {a, b, c}).(1, 2, 3)
      {1, 2, 3}

  """
  defmacro f(x, body), do: lambda([x], body)
  defmacro f(x, y, body), do: lambda([x, y], body)
  defmacro f(x, y, z, body), do: lambda([x, y, z], body)
  defmacro f(x, y, z, t, body), do: lambda([x, y, z, t], body)

  @doc """
  Defines an anonymous function with arity 1, it's parameter can be accessed with `x` var

  ## Examples

      iex> double = f(x * 2)
      iex> double.(10)
      20

      iex> greater_than_10 = f(x > 10)
      iex> greater_than_10.(1)
      false
      iex> greater_than_10.(100)
      true

      iex> Enum.map(1..5, f(x * x))
      [1, 4, 9, 16, 25]

      iex> x = :some_var_in_env
      iex> f(x).(100)
      100
      iex> x
      :some_var_in_env

  """
  defmacro f(body), do: lambda([Macro.var(:x, nil)], body)

  def lambda(params, body) do
    quote do
      fn unquote_splicing(params) -> unquote(body) end
    end
  end
end
