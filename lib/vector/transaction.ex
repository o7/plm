defmodule FIN.Rows.Transaction do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Record
  require ERP
  require Logger

  def doc(),
    do:
      "This is the transaction representation. " <>
        "Used to draw the account transactions"

  def id(), do: ERP."Payment"(volume: {0, 1})

  def new(name, ERP."Payment"(subaccount: acc, price: p, volume: v, from: tic, type: cur)) do
    {s, m} = :dec.mul(p, v)

    x =
      case cur do
        :crypto -> s
        :fiat -> 2
        _ -> 2
      end

    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column66,
          body: acc
        ),
        panel(
          class: :column10,
          body: :erlang.float_to_list(m * :math.pow(10, -s), [{:decimals, x}])
        ),
        panel(
          class: :column10,
          body: tic
        )
      ]
    )
  end
end
