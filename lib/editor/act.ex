defmodule PLM.Act do
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

  def doc(), do: "Dialog for creation of BPE processes."
  def id(), do: {:pi, []}

  def new(name, {:pi, _code}) do
    document(
      name: FORM.atom([:pi, name]),
      sections: [sec(name: "New process: ")],
      buttons: [
        but(
          id: FORM.atom([:pi, :decline]),
          title: "Discard",
          class: :cancel,
          postback: {:Discard, []}
        ),
        but(
          id: FORM.atom([:pi, :proceed]),
          title: "Create",
          class: [:button, :sgreen],
          sources: [:process_type],
          postback: {:Spawn, []}
        )
      ],
      fields: [
        field(
          name: :process_type,
          id: :process_type,
          type: :select,
          title: "Type",
          tooltips: [],
          options: [
            opt(name: PLM.Account, title: "Client Acquire [QUANTERALL]"),
            opt(name: PLM.Account, title: "Client Tracking [QUANTERALL]"),
            opt(
              name: PLM.Account,
              checked: true,
              title: "Client Account [SYNRC BANK]"
            )
          ]
        )
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
      {:error, :not_found} ->
        NITRO.update(:n, "ERR")
        NITRO.update(:desc, "No process found.")
        NITRO.update(:num, "ERR")

      _ ->
        NITRO.insert_top(:tableHead, PLM.Act.header())
        NITRO.update(:n, bin)
        NITRO.update(:num, bin)
    end

    history = BPE.hist(id)

    for i <- history,
        do:
          NITRO.insert_bottom(
            :tableRow,
            PLM.Trace.new(FORM.atom([:trace, NITRO.to_list(hist(i, :id))]), i)
          )
  end

  def event(any), do: IO.inspect(any)
end
