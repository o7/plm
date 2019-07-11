defmodule PLM.Rows.Product do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require ERP
  require Logger
  require Record

  def doc(),
    do: "PLM product."

  def id(), do: ERP."Product"()
  def mul({a,b},{c,d}), do: {a+c,b*d}

  def sum(feed) do
     {_,b} = :lists.foldl(fn (ERP."Payment"(volume: v, price: p),{x,y}) ->
        {_,y1}= mul(v,p)
        {x,y+y1} end, {0, 0}, :kvs.all feed)
     b
  end

  def new(name, prod) do
    code = ERP."Product"(prod, :code) |> NITRO.to_binary()
    income = (("/plm/" <> code <> "/income") |> :erlang.binary_to_list |> sum)
    outcome = (("/plm/" <> code <> "/outcome") |> :erlang.binary_to_list |> sum)
    panel(
      id: FORM.atom([:tr, name]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: link(href: "cashflow.htm?p=" <> code, body: code)
        ),
        panel(
          class: :column6,
          body: "Total Income: " <> NITRO.to_binary(income) <> "<br>" <>
                "Gross Profit: " <> NITRO.to_binary(income-outcome) <> "<br>"
        ),
        panel(
          class: :column20,
          body: :string.join(:lists.map(fn (ERP."Person"(cn: id, hours: h)) -> id ++  ' (' ++ :erlang.integer_to_list(h) ++')'
      end, :kvs.all '/plm/'++ :erlang.binary_to_list(code) ++ '/staff'), ',')
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
