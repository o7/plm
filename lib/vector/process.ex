defmodule PLM.Rows.Process do
  use N2O, with: [:n2o, :nitro]
  use FORM, with: [:form]
  use BPE
  require Logger
  require Record

  def doc(),
    do:
      "This is the actor table row representation in FORM CSS. Used to draw active processes" <>
        " in <a href=\"bpe.htm\">BPE process table</a> but displayed as class=form."

  def id(), do: process()

  def new(name, proc) do
    pid = process(proc, :id)

    panel(
      id: FORM.atom([:tr, name]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body:
            link(
              href: "act.htm?p=" <> NITRO.to_binary(pid),
              body: NITRO.to_binary(pid)
            )
        ),
        panel(class: :column6, body: NITRO.to_list(process(proc, :name))),
        panel(
          class: :column6,
          body: NITRO.to_list(task(BPE.step(process(proc, :task), proc), :module))
        ),
        panel(
          class: :column20,
          body:
            case BPE.head(pid) do
              [] -> []
              x -> NITRO.to_list(:erlang.element(2, hist(x, :task)))
            end
        ),
        panel(
          class: :column20,
          body:
            :string.join(
              :lists.map(
                fn x -> NITRO.to_list([:erlang.element(1, x)]) end,
                task(BPE.step(process(proc, :task), proc), :prompt)
              ),
              ', '
            )
        ),
        panel(
          class: :column10,
          body:
            case process(proc, :task) do
              :Final ->
                []

              _ ->
                [
                  link(
                    postback: {:complete, process(proc, :id)},
                    class: [:button, :sgreen],
                    body: "Go",
                    source: [],
                    validate: []
                  )
                ]
            end
        )
      ]
    )
  end
end
