defmodule PLM.Forms.Act do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Logger

  def doc(), do: "Dialog for creation of BPE processes."
  def id(), do: {:pi, []}

  def new(name, {:pi, _code}) do
    document(
      name: FORM.atom([:pi, name]),
      sections: [sec(name: "New process: ")],
      buttons: [
        but(
          id: FORM.atom([:pi, :decline]),
          title: "Discard",
          class: :cancel,
          postback: {:Discard, []}
        ),
        but(
          id: FORM.atom([:pi, :proceed]),
          title: "Create",
          class: [:button, :sgreen],
          sources: [:process_type],
          postback: {:Spawn, []}
        )
      ],
      fields: [
        field(
          name: :process_type,
          id: :process_type,
          type: :select,
          title: "Type",
          tooltips: [],
          options: [
            opt(name: PLM.Account, title: "Client Acquire [QUANTERALL]"),
            opt(name: PLM.Account, title: "Client Tracking [QUANTERALL]"),
            opt(
              name: PLM.Account,
              checked: true,
              title: "Client Account [SYNRC BANK]"
            )
          ]
        )
      ]
    )
  end
end
