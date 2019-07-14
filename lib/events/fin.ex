defmodule FIN.Index do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require ERP
  require Logger

  def accountsHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column33, body: "Account"),
        panel(class: :column10, body: "Type"),
        panel(class: :column2, body: "Ballance")
      ]
    )
  end

  def txsHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column66, body: "Account"),
        panel(class: :column10, body: "Amount"),
        panel(class: :column10, body: "Datetime")
      ]
    )
  end

  def pushAccounts(code) do
    code
  end

  def pushTxs(code) do
    code
  end

  def event(:init) do
    NITRO.clear(:frms)
    NITRO.clear(:ctrl)
    NITRO.clear(:accountsHead)
    NITRO.clear(:accountsRow)
    NITRO.clear(:txsHead)
    NITRO.clear(:txsRow)
    case N2O.user() do
      [] ->
        NITRO.hide(:head)
        PLM.box(
          PLM.Forms.Error,
          {:error, 1, "Not authenticated", "User must be authenticated in order to view account and transactions"}
        )

      ERP."Employee"(person: ERP."Person"(cn: id)) ->
        event({:txs, id})
    end
  end

  def event({:txs,id}) do
    NITRO.insert_top(:accountsHead, FIN.Index.accountsHeader())
    NITRO.insert_top(:txsHead, FIN.Index.txsHeader())
    NITRO.update(:num, span(body: :kvs_adm.parse(N2O.user)))
    NITRO.hide(:frms)

    code = :p |> NITRO.qc() |> NITRO.to_list() |> pushAccounts |> pushTxs
  end

  def event({:GotIt,id}), do: NITRO.redirect("access.htm")
  def event(_), do: []
end
