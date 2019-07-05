defmodule PLM.Account do
  @moduledoc """
  `PLM.Account` is a process that handles user investments.
  """
  use BPE, with: [:bpe]
  require Record
  Record.defrecord(:close_account, [])
  Record.defrecord(:tx, [])

  def def() do
    process(
      name: "IBAN Account",
      flows: [
        sequenceFlow(source: :Created, target: :Init),
        sequenceFlow(source: :Init, target: :Upload),
        sequenceFlow(source: :Upload, target: :Payment),
        sequenceFlow(source: :Payment, target: [:Signatory, :Process]),
        sequenceFlow(source: :Process, target: [:Process, :Final]),
        sequenceFlow(source: :Signatory, target: [:Process, :Final])
      ],
      tasks: [
        userTask(name: :Created, module: PLM.Account),
        userTask(name: :Init, module: PLM.Account),
        userTask(name: :Upload, module: PLM.Account),
        userTask(name: :Signatory, module: PLM.Account),
        serviceTask(name: :Payment, module: PLM.Account),
        serviceTask(name: :Process, module: PLM.Account),
        endEvent(name: :Final, module: PLM.Account)
      ],
      beginEvent: :Init,
      endEvent: :Final,
      events: [messageEvent(name: :PaymentReceived)]
    )
  end

  def action({:request, :Created}, proc) do
    IO.inspect("First Step")
    {:reply, proc}
  end

  def action({:request, :Init}, proc) do
    IO.inspect("Second Step")
    {:reply, proc}
  end

  def action({:request, :Payment}, proc) do
    payment = BPE.doc({:payment_notification}, proc)

    case payment do
      [] -> {:reply, :Process, process(proc, docs: [tx()])}
      _ -> {:reply, :Signatory, Proc}
    end
  end

  def action({:request, :Signatory}, proc) do
    {:reply, :Process, proc}
  end

  def action({:request, :Process}, proc) do
    case BPE.doc(close_account(), proc) do
      close_account() -> {:reply, :Final, proc}
      _ -> {:reply, proc}
    end
  end

  def action({:request, :Upload}, proc), do: {:reply, proc}
  def action({:request, :Final}, proc), do: {:reply, proc}
end
