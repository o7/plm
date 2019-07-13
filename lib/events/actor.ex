defmodule PLM.Actor do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
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

  def error() do
    NITRO.update(:num, "ERR")
    NITRO.update(:desc, "No process found.")
  end

  def ok(id) do
    NITRO.insert_top(:tableHead, PLM.Actor.header())
    NITRO.update(:num, id)
    NITRO.update(:n, id)

    for i <- BPE.hist(id),
        do:
          NITRO.insert_bottom(
            :tableRow,
            PLM.Rows.Trace.new(FORM.atom([:trace, NITRO.to_list(hist(i, :id))]), i)
          )
  end

  def event(:init) do
    NITRO.clear(:tableHead)
    NITRO.clear(:tableRow)

    case KVS.get('/bpe/proc', :p |> NITRO.qc() |> NITRO.to_list()) do
      {:error, _} -> error()
      {:ok, process(id: id)} -> ok(id)
    end
  end

  def event(_), do: []
end
