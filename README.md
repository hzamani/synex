# Synex

Collection of Elixir syntactic sugars.

## keys/1

Something like [ES6 property shorthand](http://es6-features.org/#PropertyShorthand),
or Clojure's [destructuring](http://clojure.org/guides/destructuring).
It expands keywords, maps and structs, and supports variable pinning and map update syntax.

For examples look at `Synex.Keys.keys/1`.

## params/1

Like `keys/1` but only for maps and uses string keys instead of atoms.
`params/1` also expands nested maps.

```elixir
iex> params(%{a => %{b, c}}) = %{"a" => %{"b" => 2, "c" => 3}}
iex> {b, c}
{2, 3}
iex> a
%{"b" => 2, "c" => 3}
```

For more examples look at `Synex.Params.params/1`.

## Installation

1. Add `synex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:synex, "~> 1.0"}]
end
```

2. Add `use Synex` to your module.

