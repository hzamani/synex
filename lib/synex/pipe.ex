defmodule Synex.Pipe do
  defmacro pipe(exp, [do: {:__block__, _, funcs}]) do
    expand(exp, funcs)
  end

  defmacro pipe(exp, [do: func]) do
    expand(exp, [func])
  end

  defmacro pipe(exp, funcs) do
    expand(exp, funcs)
  end

  defmacro pipe([do: {:__block__, _, [exp | funcs]}]) do
    expand(exp, funcs)
  end

  defmacro pipe([do: exp]) do
    expand(exp, [])
  end

  defmacro pipe([exp | funcs]) do
    expand(exp, funcs)
  end

  defp expand(exp, []), do: exp

  defp expand(exp, [{name, meta, args} | funcs]) when is_atom(args) do
    expand({name, meta, [exp]}, funcs)
  end

  defp expand(exp, [{:f, meta, [body]} | funcs]) do
    func = {{:., meta, [{:f, meta, [body]}]}, meta, [exp]}
    expand(func, funcs)
  end

  defp expand(exp, [{name, meta, args} | funcs]) when is_list(args) do
    expand({name, meta, [exp | args]}, funcs)
  end

  defp expand(_, _) do
    raise ArgumentError, "unacceptable inputs passed to pipe"
  end
end
