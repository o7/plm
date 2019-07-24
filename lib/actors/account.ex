defmodule BPE.Account do
  @moduledoc """
  `PLM.Account` is a process that handles user investments.
  """
  require ERP
  require BPE
  require Record
  Record.defrecord(:close_account, [])
  Record.defrecord(:tx, [])

  def def() do
    BPE.process(
      name: :n2o.user(),
      flows: [
        BPE.sequenceFlow(source: :Created, target: :Init),
        BPE.sequenceFlow(source: :Init, target: :Upload),
        BPE.sequenceFlow(source: :Upload, target: :Payment),
        BPE.sequenceFlow(source: :Payment, target: [:Signatory, :Process]),
        BPE.sequenceFlow(source: :Process, target: [:Process, :Final]),
        BPE.sequenceFlow(source: :Signatory, target: [:Process, :Final])
      ],
      tasks: [
        BPE.userTask(name: :Created, module: BPE.Account),
        BPE.userTask(name: :Init, module: BPE.Account),
        BPE.userTask(name: :Upload, module: BPE.Account),
        BPE.userTask(name: :Signatory, module: BPE.Account),
        BPE.serviceTask(name: :Payment, module: BPE.Account),
        BPE.serviceTask(name: :Process, module: BPE.Account),
        BPE.endEvent(name: :Final, module: BPE.Account)
      ],
      beginEvent: :Init,
      endEvent: :Final,
      events: [BPE.messageEvent(name: :PaymentReceived)]
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
    payment = :bpe.doc({:payment_notification}, proc)

    case payment do
      [] -> {:reply, :Process, BPE.process(proc, docs: [tx()])}
      _ -> {:reply, :Signatory, Proc}
    end
  end

  def action({:request, :Signatory}, proc) do
    {:reply, :Process, proc}
  end

  def action({:request, :Process}, proc) do
    case :bpe.doc(close_account(), proc) do
      close_account() -> {:reply, :Final, proc}
      _ -> {:reply, proc}
    end
  end

  def action({:request, :Upload}, proc), do: {:reply, proc}
  def action({:request, :Final}, proc), do: {:reply, proc}
end
