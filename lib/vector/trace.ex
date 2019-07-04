defmodule PLM.Trace do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Logger

  def doc(),
    do:
      "This is the actor trace row (step) representation. " <>
        "Used to draw trace of the processes"

  def id(), do: hist(task: {:task, :Init})

  def new(name, h) do
    task =
      case hist(h, :task) do
        [] -> hist(id(), :task)
        x -> x
      end

    docs = hist(h, :docs)

    panel(
      id: FORM.atom([:tr, NITRO.to_list(name)]),
      class: :td,
      body: [
        panel(
          class: :column6,
          body: :io_lib.format("~s", [NITRO.to_list(:erlang.element(2, task))])
        ),
        panel(
          class: :column20,
          body:
            :string.join(
              :lists.map(
                fn x -> NITRO.to_list([:erlang.element(1, x)]) end,
                docs
              ),
              ', '
            )
        )
      ]
    )
  end
end
