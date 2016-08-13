defmodule Synex do
  defmacro __using__([]) do
    quote do
      import Synex.Keys
      import Synex.Params
    end
  end
end
