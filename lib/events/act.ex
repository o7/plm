defmodule BPE.Actor do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  require BPE
  require Logger

  def header() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "State"),
        panel(class: :column6, body: "Documents")
      ]
    )
  end

  def ok(id) do
    NITRO.insert_top(:tableHead, BPE.Actor.header())

    for i <- :bpe.hist(id) do
      NITRO.insert_bottom(
        :tableRow,
        BPE.Rows.Trace.new(FORM.atom([:trace, NITRO.to_list(BPE.hist(i, :id))]), i)
      )
    end
  end

  def event(:init) do
    id = :p |> NITRO.qc() |> NITRO.to_list()
    NITRO.update(:num, id)
    NITRO.update(:n, id)

    case N2O.user() do
      [] ->
        PLM.box(
          PLM.Forms.Error,
          {:error, 1, "Not authenticated",
           "User must be authenticated in order to view the process trace.<br>" <>
             "You can do that at <a href=\"ldap.htm\">LDAP</a> page."}
        )

      _ ->
        event({:txs, id})
    end
  end

  def event({:txs, id}) do
    NITRO.clear(:tableHead)
    NITRO.clear(:tableRow)

    case KVS.get('/bpe/proc', id) do
      {:error, _} -> PLM.box(PLM.Forms.Error, {:error, 2, "No process found.", []})
      {:ok, BPE.process(id: id)} -> ok(id)
    end
  end

  def event({:off, _}), do: NITRO.redirect("bpe.htm")
  def event(_), do: []
end
