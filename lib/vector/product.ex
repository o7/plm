defmodule PLM.Rows.Product do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require ERP
  require Logger
  require Record

  def doc(),
    do: "PLM product."

  def id(), do: ERP."Product"()

  def new(name, prod) do
    code = ERP."Product"(prod, :code) |> NITRO.to_binary

    panel(
      id: FORM.atom([:tr, name]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: link(href: "product.htm?p=" <> code, body: code)
        ),
        panel(
          class: :column6,
          body: "EBITDA:<br>ROI:<br>Revenue:"
        ),
        panel(
          class: :column20,
          body: "Maxim"
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
          body: link(class: [:sgreen, :button], postback: {:invest,code}, body: "Invest")
        )
      ]
    )
  end
end
