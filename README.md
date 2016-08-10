# Synex

Collection of Elixir syntactic sugars.

## Keys

Something like [ES6 property shorthand](http://es6-features.org/#PropertyShorthand),
or Clojure's [destructuring](http://clojure.org/guides/destructuring), for exmaple:

```elixir
name = "Synex"
version = 1
package = keys(%{name, version})
```

will expand to `%{name: "Synex", version: 1}`

Can be used in matches:

```elixir
keys(%{a, b, c: 3}) = %{a: 1, b: 2, c: 3}
1 = a
2 = b
```

It supports pinning variables:

```elixir
keys(%{^a, ^b}) = %{a: 1, b: 2}
```

It supports map update syntax:

```elixir
version = 2
keys(%{package | version})
# => %{name: "Synex", version: 2}
```

It also expands keywords:

```elixir
def range(keys([from, to, by])) do
  pipe from do
    Stream.iterate f(x + by)
    Enum.take_while f(x <= to)
  end
end
rage(from: 10, to: 30, by: 5)
# => [10, 15, 20, 25, 30]
```

Note: `pipe` and `f` are other syntactic sugars, listed below.

Structs are supported too:

```elixir
defmodule Package do
  defstruct [:name, :version]
end

keys(%Package{name, version})
# => %Package{name: "Synex", version: 2}
```

## Params

Like `keys` but only for maps and use string keys instead of atoms.

```elixir
name = "Synex"
version = 1
params(%{name, version})
# => %{"name" => "Synex", "version" => 1}
```

It also supports nested maps:

```elixir
params(%{a => %{b, c}}) = %{"a" => %{"b" => 10, "c" => 100, "d" => 200}}
%{"b" => 10, "c" => 100, "d" => 200} = a
10 = b
100 = c
params(%{^a => %{b, c}}) = %{"a" => %{"b" => 10, "c" => 100, "d" => 200}}
```

It's name is params as I use it in Phoenix for matching params!

## Lambda

Lambda is a shorthand for small anonymous functions.

`f`'s last argument is the function expression and others are the function arguments.

```elixir
f(n, n + 10)       # fn n -> n + 10 end
f({name, _}, name) # fn {name, _} -> name end
f(a, b, a + b)     # fn a, b -> a + b end
```

That's for `f/2` through `f/5`.

`f/1` has a special behavior, it has `x` as it's only parameter:

```elixir
f(x + 10)          # fn x -> x + 10 end
f(x >= 10)         # fn x -> x >= 10 end
```

## Pipe

Whit `pipe` you can pipe function calls without pipe operator:

```elixir
pipe 1..10 do
  Enum.map f(x + 10)
  Enum.filter f(x > 15)
end
# => [16, 17, 18, 19, 20]
```

## Installation

1. Add `synex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:synex, "~> 1.0"}]
end
```

2. Add `use Synex` to your module.

