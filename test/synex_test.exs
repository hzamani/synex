defmodule SynexTest do
  use ExUnit.Case
  use Synex

  defmodule Person do
    defstruct name: "", age: 10, languages: []
  end

  doctest Synex.Keys
  doctest Synex.Params
end
