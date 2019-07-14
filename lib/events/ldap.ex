defmodule LDAP.Index do
  use N2O, with: [:n2o, :nitro]
  use FORM
  require ERP
  require Logger

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
        PLM.box(
          PLM.Forms.Error,
          {:error, 1, "The user cannot be found in this branch.", []}
        )
    end
  end

  def event({:Close, _}), do: NITRO.redirect("index.html")
  def event({:revoke, x}), do: [N2O.user([]), event({:GotIt, x})]
  def event(:access), do: PLM.box(LDAP.Forms.Access, [])
  def event({:GotIt, _}), do: PLM.box(LDAP.Forms.Credentials, [])
  def event(_), do: []
end
