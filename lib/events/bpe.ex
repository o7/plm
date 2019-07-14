defmodule BPE.Index do
  require Logger
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM
  require BPE
  require KVS
  def index_header() do
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
    NITRO.insert_top(:tableHead, index_header())
    NITRO.clear(:frms)
    NITRO.clear(:ctrl)
    mod = BPE.Forms.Create
    NITRO.insert_bottom(:frms, FORM.new(mod.new(mod, mod.id()), mod.id()))

    NITRO.insert_bottom(
      :ctrl,
      link(
        id: :creator,
        body: "New Process",
        postback: :create,
        class: [:button, :sgreen]
      )
    )

    NITRO.hide(:frms)

    for BPE.process(id: i) <-
          Enum.filter(
            KVS.feed('/bpe/proc'),
            fn BPE.process(name: n) -> n == :n2o.user() end
          ) do
      NITRO.insert_bottom(:tableRow, BPE.Rows.Process.new(FORM.atom([:row, i]), :bpe.load(i)))
    end
  end

  def event({:complete, id}) do
    p = :bpe.load(id)
    :bpe.start(p, [])
    :bpe.complete(id)

    NITRO.update(
      FORM.atom([:tr, :row, id]),
      BPE.Rows.Process.new(FORM.atom([:row, id]), :bpe.proc(id))
    )
  end

  def event({:Spawn, _}) do
    atom = 'process_type_pi_Elixir.BPE.Forms.Create' |> NITRO.q() |> NITRO.to_atom()

    id =
      case :bpe.start(atom.def(), []) do
        {:error, i} -> i
        {:ok, i} -> i
      end

    NITRO.insert_after(
      :header,
      BPE.Rows.Process.new(FORM.atom([:row, id]), :bpe.proc(id))
    )

    NITRO.hide(:frms)
    NITRO.show(:ctrl)
  end

  def event({:Discard, []}), do: [NITRO.hide(:frms), NITRO.show(:ctrl)]
  def event(:create), do: [NITRO.hide(:ctrl), NITRO.show(:frms)]
  def event(_), do: []
end
