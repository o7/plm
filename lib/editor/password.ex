defmodule PLM.Forms.Pass do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require Logger
  require Record

  Record.defrecord(:phone, code: "+380676631870", number: "0000")

  def doc(), do: "One-time password PIN."
  def id(), do: phone()

  def new(name, _phone) do
    document(
      name: FORM.atom([:otp, name]),
      sections: [sec(name: "Input the credentials: ")],
      buttons: [
        but(
          id: :decline,
          name: :decline,
          title: "Cancel",
          class: :cancel,
          postback: {:Close, []}
        ),
        but(
          id: :sms,
          name: :sms,
          title: "SMS",
          class: :cancel,
          sources: [:cn, :branch, :otp],
          postback: {:SMS, []}
        ),
        but(
          id: :proceed,
          name: :proceed,
          title: "Proceed",
          class: [:button, :sgreen],
          sources: [:company, :otp, :cn, :branch],
          postback: {:Next, name}
        )
      ],
      fields: [
        field(
          name: :company,
          id: :company,
          type: :select,
          title: "Company:",
          tooltips: [],
          pos: 1,
          options: [
            opt(
              name: 'quanterall',
              checked: true,
              title: "Quanterall"
            )
          ]
        ),
        field(
          name: :branch,
          id: :branch,
          type: :select,
          pos: 2,
          title: "Branch:",
          tooltips: [],
          options: [
            opt(name: '/acc/quanterall/Plovdiv', title: "Plovdiv"),
            opt(name: '/acc/quanterall/Sophia', title: "Sophia"),
            opt(
              name: '/acc/quanterall/Varna',
              checked: true,
              title: "Varna (HQ)"
            )
          ]
        ),
        field(
          pos: 3,
          id: :cn,
          name: :cn,
          type: :string,
          title: "Common Name:",
          labelClass: :label,
          fieldClass: :column3
        ),
        field(
          pos: 4,
          id: :otp,
          name: :otp,
          type: :otp,
          title: "Passphrase:",
          labelClass: :label,
          fieldClass: :column3
        )
      ]
    )
  end
end
