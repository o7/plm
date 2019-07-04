defmodule PLM.Forms do
  use N2O, with: [:n2o, :nitro, :form]
  require Logger

  def event({:client, {:form, mod}}) do
    NITRO.insert_bottom(:stand, h3(body: NITRO.to_binary(mod)))

    NITRO.insert_bottom(
      :stand,
      h5(body: mod.doc(), style: "margin-bottom: 10px;")
    )

    NITRO.insert_bottom(
      :stand,
      panel(FORM.new(mod.new(mod, mod.id()), mod.id()), class: :form)
    )
  end

  def event(:init) do
    NITRO.clear(:stand)

    for f <- :application.get_env(:form, :registry, []) do
      send(self(), {:client, {:form, f}})
    end
  end

  def event({ev, name}) do
    NITRO.wire(
      :lists.concat([
        'console.log(\"',
        :io_lib.format('~p', [{ev, name}]),
        '\");'
      ])
    )
  end

  def event(any), do: IO.inspect(any)
end
