defmodule PLM.Login do
  use N2O, with: [:n2o, :nitro]
  use FORM
  require ERP
  require Logger

  def api_event(_, _, _), do: IO.inspect("API EVENT~n")
  def event({:SMS, _}), do: NITRO.wire("document.getCookies('sample string');")
  def event({:Close, _}), do: NITRO.redirect("index.html")

  def event(:init) do
    case N2O.user() do
      [] -> event({:GotIt, []})
       _ -> event(:access)
    end
  end

  def event({:Next, form}) do
    cn = PLM.extract(:cn, :otp, form)
    branch = PLM.extract(:branch, :otp, form)

    case PLM.auth(cn, branch) do
      {:ok, p} ->
        N2O.user(p)
        NITRO.redirect("plm.htm")

      {:error, _} ->
        NITRO.clear(:stand)
        NITRO.clear(:stand)
        mod = PLM.Forms.Error
        rec = {:error, [], "The user cannot be found in this branch."}
        NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
    end
  end

  def event(:access) do
    NITRO.clear(:stand)
    mod = PLM.Forms.Access
    rec = mod.id
    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
  end

  def event({:revoke,x}) do
    N2O.user []
    event({:GotIt, x})
  end

  def event({:GotIt, _}) do
    NITRO.clear(:stand)
    mod = PLM.Forms.Pass
    rec = mod.id
    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, rec), rec))
  end

  def event(_), do: []
end
