defmodule PLM.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :plm,
      version: "0.6.0",
      elixir: "~> 1.7",
      description: "PLM Product Lifecycle Management",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(doc src mix.exs LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :pm,
      links: %{"GitHub" => "https://github.com/enterprizing/plm"}
    ]
  end

  def application() do
    [mod: {:plm, []}]
  end

  def deps() do
    [
      {:ex_doc, "~> 0.11", only: :dev}
    ]
  end
end
