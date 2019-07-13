defmodule PLM do
  use N2O, with: [:nitro]
  use FORM
  def extract(name, path, form), do: [name, path, form] |> FORM.atom() |> NITRO.q() |> NITRO.to_list()

  def box(mod, r) do
    NITRO.clear(:stand)

    rec =
      case r do
        [] -> mod.id
        x -> x
      end

    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
  end

  def auth(cn, branch) do
    case :kvs.get(:PersonCN, cn) do
      {:ok, {:PersonCN, _, acc}} ->
        case :kvs.get(branch, acc) do
          {:ok, p} -> {:ok, p}
          x -> x
        end

      x ->
        x
    end
  end
end

defmodule PLM.Application do
  use Application

  def start(_, _) do
    :cowboy.start_tls(:http, :n2o_cowboy.env(:plm), %{env: %{dispatch: :n2o_cowboy2.points()}})
    :n2o.start_ws()
    Supervisor.start_link([], strategy: :one_for_one, name: PLM.Supervisor)
  end
end
