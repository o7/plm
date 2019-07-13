defmodule PLM.Forms.Error do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require Logger
  require Record

  def doc(), do: "Error Form."
  def id(), do: {:error, [], "General Error", []}

  def new(name, {:error, no, msg, body}) do
    panel(
      class: :form,
      body: [
        h4(body: "ERROR: " <> msg),
        p(style: "margin: 20;", body: body),
        panel(
          class: :buttons,
          body: link(class: [:button, :sgreen], body: "Got it", id: name, postback: {:GotIt, no})
        )
      ]
    )
  end
end
