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

  def new(name, ERP."Investment"(id: id, to: tic)) do
    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: id
        ),
        panel(
          class: :column20,
          body: tic
        )
      ]
    )
  end
end
