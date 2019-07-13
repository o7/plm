defmodule PLM.Login do
  use N2O, with: [:n2o, :nitro]
  use FORM
  require ERP
  require Logger

  def api_event(_, _, _), do: IO.inspect("API EVENT~n")
  def extract(name, path, form), do: [name, path, form] |> FORM.atom() |> NITRO.q() |> NITRO.to_list()
  def event({:SMS, _}), do: NITRO.wire("document.getCookies('sample string');")
  def event({:Close, _}), do: NITRO.redirect("index.html")

  def event(:init) do
    NITRO.cookie('hello', 'world')
    NITRO.wire(api(name: 'getCookies', delegate: PLM.Login))
    event({:GotIt, []})
  end

  def event({:Next, form}) do
    cn = extract(:cn, :otp, form)
    branch = extract(:branch, :otp, form)
    mod = PLM.Forms.Error

    res =
      case :kvs.get(:PersonCN, cn) do
        {:error, _} ->
          :skip

        {:ok, {:PersonCN, cn, acc}} ->
          case :kvs.get(branch, acc) do
            {:ok, ERP."Employee"(id: id)} ->
              N2O.user(id)
              :ok

            {:error, _} ->
              :skip
          end
      end

    case res do
      :ok ->
        NITRO.redirect("plm.htm")

      :skip ->
        NITRO.clear(:stand)
        NITRO.clear(:stand)
        mod = PLM.Forms.Error
        rec = {:error, [], "The user cannot be found in this branch."}
        NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
    end
  end

  def event({:GotIt, _}) do
    NITRO.clear(:stand)
    mod = PLM.Forms.Pass
    rec = mod.id
    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
  end

  def event(any), do: IO.inspect(any)
end
