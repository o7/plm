defmodule PLM.Product do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Logger

  def investmentsHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "Id"),
        panel(class: :column20, body: "Amount"),
        panel(class: :column20, body: "From")
      ]
    )
  end

  def incomeHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "Invoice"),
        panel(class: :column20, body: "Amount"),
        panel(class: :column20, body: "From")
      ]
    )
  end

  def outcomeHeader() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "Invoice"),
        panel(class: :column20, body: "Amount"),
        panel(class: :column20, body: "From")
      ]
    )
  end

  def pushInvestments(code) do
    for i <- KVS.feed('/plm/' ++ code ++ '/investments') do
      NITRO.insert_bottom(
        :investmentsRow,
        PLM.Rows.Investment.new(FORM.atom([:row, :investment, code]), i)
      )
    end
    code
  end

  def pushIncome(code) do
    for i <- KVS.feed('/plm/' ++ code ++ '/income') do
      NITRO.insert_bottom(
        :incomeRow,
        PLM.Rows.Payment.new(FORM.atom([:row, :income, code]), i)
      )
    end
    code
  end

  def pushOutcome(code) do
    for i <- KVS.feed('/plm/' ++ code ++ '/outcome') do
      NITRO.insert_bottom(
        :outcomeRow,
        PLM.Rows.Payment.new(FORM.atom([:row, :outcome, code]), i)
      )
    end
    code
  end

  def event(:init) do
    NITRO.clear(:investmentsHead)
    NITRO.clear(:investmentsRow)
    NITRO.clear(:incomeHead)
    NITRO.clear(:incomeRow)
    NITRO.clear(:outcomeHead)
    NITRO.clear(:outcomeRow)
    NITRO.insert_top(:investmentsHead, PLM.Product.investmentsHeader())
    NITRO.insert_top(:outcomeHead, PLM.Product.outcomeHeader())
    NITRO.insert_top(:incomeHead, PLM.Product.incomeHeader())

    code = :p |> NITRO.qc |> NITRO.to_list |> pushInvestments |> pushIncome |> pushOutcome

    case KVS.get(:writer, '/plm/' ++ code ++ '/income') do
      {:error, _} ->
        NITRO.update(:n, "ERR")
        NITRO.update(:desc, "No product found.")
        NITRO.update(:num, "ERR")

      _ ->
        NITRO.update(:n, code)
        NITRO.update(:num, code)
    end

  end

  def event(any), do: IO.inspect(any)
end
