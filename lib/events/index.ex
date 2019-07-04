defmodule PLM.Index do
  require Logger
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM
  use BPE

  def header() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "No"),
        panel(class: :column10, body: "Name"),
        panel(class: :column6, body: "Module"),
        panel(class: :column20, body: "State"),
        panel(class: :column20, body: "Documents"),
        panel(class: :column20, body: "Manage")
      ]
    )
  end

  def event(:init) do
    NITRO.clear(:tableRow)
    NITRO.clear(:tableHead)
    NITRO.insert_top(:tableHead, PLM.Index.header())
    NITRO.clear(:frms)
    NITRO.clear(:ctrl)
    mod = PLM.Act
    NITRO.insert_bottom(:frms, FORM.new(mod.new(mod, mod.id()), mod.id()))

    NITRO.insert_bottom(
      :ctrl,
      link(
        id: :creator,
        body: "New",
        postback: :create,
        class: [:button, :sgreen]
      )
    )

    NITRO.hide(:frms)

    for i <- KVS.feed('/bpe/proc') do
      NITRO.insert_bottom(
        :tableRow,
        PLM.Row.new(
          FORM.atom([:row, process(i, :id)]),
          BPE.load(process(i, :id))
        )
      )
    end
  end

  def event({:complete, id}) do
    p = :bpe.load(id)
    BPE.start(p, [])
    BPE.complete(id)

    NITRO.update(
      FORM.atom([:tr, :row, id]),
      PLM.Row.new(FORM.atom([:row, id]), BPE.proc(id))
    )
  end

  def event({:Spawn, _}) do
    atom = 'process_type_pi_Elixir.PLM.Act' |> NITRO.q() |> NITRO.to_atom()

    id =
      case BPE.start(atom.def(), []) do
        {:error, i} -> i
        {:ok, i} -> i
      end

    NITRO.insert_after(
      :header,
      PLM.Row.new(FORM.atom([:row, id]), BPE.proc(id))
    )

    NITRO.hide(:frms)
    NITRO.show(:ctrl)
  end

  def event({:Discard, []}), do: [NITRO.hide(:frms), NITRO.show(:ctrl)]

  def event({event, name}) do
    NITRO.wire(
      :lists.concat([
        "console.log(\"",
        :io_lib.format("~p", [{event, name}]),
        "\");"
      ])
    )

    IO.inspect({event, name})
  end

  def event(:create), do: [NITRO.hide(:ctrl), NITRO.show(:frms)]
  def event(any), do: IO.inspect(any)
end
