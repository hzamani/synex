defmodule Synex.Mixfile do
  use Mix.Project

  def project, do: [
    app: :synex,
    name: "Synex",
    version: "1.0.0",
    elixir: "~> 1.3",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    description: description(),
    package: package(),
    docs: [extras: ["README.md"]],
    deps: deps(),
  ]

  def application, do: [
    applications: [:logger]
  ]

  defp deps, do: [
    {:ex_doc, "~> 0.12", only: :dev},
  ]

  defp description, do:
    """
    Collection of syntactic sugars for elixir including
    keys, params, pipe, and shorthand lambda macro `f`
    """

  defp package, do: [
    name: :synex,
    maintainers: ["Hassan Zamani"],
    licenses: ["Apache 2.0"],
    links: %{
      "GitHub" => "https://github.com/hzamani/synex",
    }
  ]
end
