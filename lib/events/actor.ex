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

  def event(:init) do
    NITRO.clear(:tableHead)
    NITRO.clear(:tableRow)
    bin = NITRO.qc(:p)

    id =
      try do
        NITRO.to_list(bin)
      catch
        _, _ -> 0
      end

    case KVS.get('/bpe/proc', id) do
      {:error, _} ->
        NITRO.update(:n, "ERR")
        NITRO.update(:desc, "No process found.")
        NITRO.update(:num, "ERR")

      _ ->
        NITRO.insert_top(:tableHead, PLM.Actor.header())
        NITRO.update(:n, bin)
        NITRO.update(:num, bin)
    end

    history = BPE.hist(id)

    for i <- history,
        do:
          NITRO.insert_bottom(
            :tableRow,
            PLM.Rows.Trace.new(FORM.atom([:trace, NITRO.to_list(hist(i, :id))]), i)
          )
  end

  def event(any), do: IO.inspect(any)
end
