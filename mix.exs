defmodule PLM.Mixfile do
  use Mix.Project

  def project() do
    [
      app: :plm,
      version: "0.7.0",
      elixir: "~> 1.7",
      description: "PLM Product Lifecycle Management",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(doc lib src mix.exs LICENSE),
      licenses: ["ISC"],
      maintainers: ["Namdak Tonpa"],
      name: :plm,
      links: %{"GitHub" => "https://github.com/o7/PLM"}
    ]
  end

  def application() do
    [
      mod: {PLM.Application, []},
      applications: [:ranch, :cowboy, :rocksdb, :kvs, :syn, :erp, :bpe, :n2o]
    ]
  end

  def deps() do
    [
      {:ex_doc, "~> 0.11.0", only: :dev},
      {:cowboy, "~> 2.5.0"},
      {:rocksdb, "~> 1.2.0"},
      {:n2o, "~> 6.7.1"},
      {:syn, "~> 1.6.3"},
      {:kvs, "~> 6.7.4"},
      {:erp, "~> 0.7.5"},
      {:bpe, "~> 4.7.3"},
      {:nitro, "~> 4.7.2"},
      {:form, "~> 4.7.0"}
    ]
  end
end
