defmodule LDAP.Forms.Access do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  require Logger
  require Record

  def doc(), do: "Access."
  def id(), do: {:access, N2O.user() |> KVS.Index.parse(), "to all services."}

  def new(name, {:access, _user, msg}) do
    document(
      name: FORM.atom([:otp, name]),
      sections: [sec(name: "GRANTED: " <> msg)],
      buttons: [
        but(
          id: :ok,
          name: :ok,
          title: "Revoke",
          class: [:button, :sgreen],
          postback: {:revoke, name}
        )
      ],
      fields: [
        field(
          pos: 2,
          id: :cn,
          name: :cn,
          type: :string,
          disabled: true,
          title: "Logged in as:",
          fieldClass: :column3
        )
      ]
    )
  end
end
