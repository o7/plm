defmodule PLM.Rows.Investment do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Record
  require ERP
  require Logger

  def doc(),
    do:
      "This is the actor trace row (step) representation. " <>
        "Used to draw trace of the processes"

  def id(), do: ERP."Payment"(volume: {0,1})

  def new(name, ERP."Payment"(invoice: id, price: p, volume: v, from: tic)) do
    {s,m} = :dec.mul(p,v)
    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column33,
          body: "option"
        ),
        panel(
          class: :column10,
          body: :erlang.float_to_list(m*:math.pow(10,-s),[{:decimals, s}])
        ),
        panel(
          class: :column2,
          body: tic
        )
      ]
    )
  end
end
