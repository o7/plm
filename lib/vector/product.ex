defmodule PLM.Rows.Product do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require ERP
  require Logger
  require Record

  def doc(),
    do: "PLM product."

  def id(), do: ERP."Product"(code: 'NYNJA')
  def mul({a, b}, {c, d}), do: {a + c, b * d}

  def sum(feed) do
    {_, b} =
      :lists.foldl(
        fn ERP."Payment"(volume: v, price: p), {x, y} ->
          {_, y1} = mul(v, p)
          {x, y + y1}
        end,
        {0, 0},
        :kvs.all(feed)
      )

    b
  end

  def new(name, prod) do
    code = ERP."Product"(prod, :code)
    income = ('/plm/' ++ code ++ '/income') |> sum
    outcome = ('/plm/' ++ code ++ '/outcome') |> sum
    feed = '/fin/acc/' ++ code
    {:ok, ERP."Acc"(rate: {_, rnd})} = :kvs.get(feed, code ++ '/R&D')
    {:ok, ERP."Acc"(rate: {_, ins})} = :kvs.get(feed, code ++ '/insurance')
    {:ok, ERP."Acc"(rate: {_, opt})} = :kvs.get(feed, code ++ '/options')
    {:ok, ERP."Acc"(rate: {_, rsv})} = :kvs.get(feed, code ++ '/reserved')

    panel(
      id: FORM.atom([:tr, name]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: link(href: 'cashflow.htm?p=' ++ code, body: code)
        ),
        panel(
          class: :column6,
          body:
            "Total Income: " <>
              NITRO.to_binary(income) <>
              "<br>" <>
              "Gross Profit: " <>
              NITRO.to_binary(income - outcome) <>
              "<br>" <>
              "R&D: " <>
              NITRO.to_binary(rnd) <>
              "%<br>" <>
              "options: " <>
              NITRO.to_binary(opt) <>
              "%<br>" <>
              "reserved: " <>
              NITRO.to_binary(rsv) <>
              "%<br>" <>
              "credited: " <> NITRO.to_binary(ins) <> "%<br>"
        ),
        panel(
          class: :column20,
          body:
            :string.join(
              :lists.map(
                fn ERP."Person"(cn: id, hours: h) ->
                  id ++ '&nbsp;(' ++ :erlang.integer_to_list(h) ++ ')'
                end,
                :kvs.all('/plm/' ++ code ++ '/staff')
              ),
              ','
            )
        ),
        panel(
          class: :column30,
          body:
            panel(
              class: :chart,
              body: "<canvas heigh=100 id=\"" <> NITRO.to_binary(name) <> "\"></canvas>"
            )
        ),
        panel(
          class: :column6,
          body: link(class: [:sgreen, :button], postback: {:invest, code}, body: "Invest")
        )
      ]
    )
  end
end
