defmodule FIN.Rows.Account do
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

  def id(), do: ERP."Acc"(id: 'Anon/local', ballance: {0, 1})

  def new(name, ERP."Acc"(id: acc, ballance: p, rate: v, type: type)) do
    [h,t] = :string.tokens(acc, '/')
    {s, m} = :dec.mul(p, v)

    x =
      case type do
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
          body: t
        ),
        panel(
          class: :column10,
          body: type
        ),
        panel(
          class: :column10,
          body: :erlang.float_to_list(m * :math.pow(10, -s), [{:decimals, x}])
        )
      ]
    )
  end
end
