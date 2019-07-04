defmodule PLM.Product do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require ERP
  require Logger
  require Record

  def doc(),
    do: "PLM product."

  def id(), do: ERP."Product"()

  def new(name, prod) do
    panel(
      id: FORM.atom([:tr, name]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: link(href: "#", body: NITRO.to_binary(ERP."Product"(prod, :code)))
        ),
        panel(
          class: :column6,
          body: NITRO.to_list(ERP."Product"(prod, :type))
        ),
        panel(class: :column6, body: ""),
        panel(
          class: :column20,
          body: ""
        ),
        panel(
          class: :column20,
          body:
            panel(
              class: :chart,
              body: "<canvas id=\"" <> NITRO.to_binary(name) <> "\"></canvas>"
            )
        ),
        panel(
          class: :column6,
          body: link(class: [:sgreen, :button], postback: :null, body: "Invest")
        )
      ]
    )
  end
end
