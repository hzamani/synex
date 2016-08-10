defmodule Synex.Params do
  import Synex.Lambda
  import Synex.Pipe

  defmacro params(data), do: expand(data)

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
