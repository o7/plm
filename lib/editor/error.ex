defmodule PLM.Forms.Error do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require Logger
  require Record

  def doc(), do: "Error Form."
  def id(), do: {:error, [], "General Error"}

  def new(name, {:error, [], msg}) do
    document(
      name: FORM.atom([:otp, name]),
      sections: [sec(name: "ERROR: " <> msg)],
      buttons: [
        but(
          id: :ok,
          name: :ok,
          title: "Got it!",
          class: [:button, :sgreen],
          postback: {:GotIt, name}
        )
      ],
      fields: []
    )
  end
end
