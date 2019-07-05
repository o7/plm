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
          sources: [:user, :otp],
          postback: {:SMS, []}
        ),
        but(
          id: :proceed,
          name: :proceed,
          title: "Proceed",
          class: [:button, :sgreen],
          sources: [:user, :otp],
          postback: {:Next, FORM.atom([:otp, :otp, name])}
        )
      ],
      fields: [
        field(
          id: :user,
          name: :user,
          type: :string,
          title: "Login:",
          labelClass: :label,
          pos: 2,
          fieldClass: :column3
        ),
        field(
          id: :otp,
          name: :otp,
          type: :otp,
          title: "Pass:",
          labelClass: :label,
          pos: 3,
          fieldClass: :column3
        )
      ]
    )
  end
end
