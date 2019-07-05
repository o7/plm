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

  def id(), do: ERP."Investment"()

  def new(name, ERP."Investment"(id: id, price: {_, price}, volume: {_, volume}, from: tic)) do
    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column33,
          body: id
        ),
        panel(
          class: :column10,
          body: :erlang.integer_to_list(price * volume)
        ),
        panel(
          class: :column2,
          body: tic
        )
      ]
    )
  end
end
