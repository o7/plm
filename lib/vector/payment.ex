defmodule PLM.Rows.Payment do
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

  def id(), do: ERP."Payment"()

  def new(name, ERP."Payment"(invoice: id, price: {_, price}, volume: {_, volume}, from: tic)) do
    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column66,
          body: id
        ),
        panel(
          class: :column10,
          body: :erlang.integer_to_list(price * volume)
        ),
        panel(
          class: :column10,
          body: "NYNJA"
        )
      ]
    )
  end
end
