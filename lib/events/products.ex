defmodule PLM.Products do
  require Logger
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM
  use BPE
  require ERP

  def header() do
    panel(
      id: :header,
      class: :th,
      body: [
        panel(class: :column6, body: "Code"),
        panel(class: :column10, body: "Type"),
        panel(class: :column6, body: "People"),
        panel(class: :column20, body: "Overall"),
        panel(class: :column20, body: "Income"),
        panel(class: :column20, body: "Details")
      ]
    )
  end

  def months() do
    zip =
      :lists.zip(:lists.seq(1, 12), [
        :Jan,
        :Feb,
        :Mar,
        :Apr,
        :May,
        :Jun,
        :Jul,
        :Aug,
        :Sep,
        :Oct,
        :Nov,
        :Dec
      ])

    {{_, x, _}, _} = :calendar.local_time()
    {a, b} = :lists.split(x, zip)
    piz = b ++ a
    half = :lists.reverse(:lists.sublist(:lists.reverse(piz, 1), 6))

    {x, :lists.flatten(:io_lib.format("~p", [:erlang.element(2, :lists.unzip(half))]))}
  end

  def event(:init) do
    NITRO.clear(:tableRow)
    NITRO.clear(:tableHead)
    NITRO.insert_top(:tableHead, PLM.Products.header())

    for i <- KVS.feed('/plm/products') do
      code = ERP."Product"(i, :code)
      _ = KVS.head('/plm/' ++ code ++ '/payments', 24)

      NITRO.insert_bottom(
        :tableRow,
        PLM.Product.new(code, i)
      )

      {_, x} = months()
      NITRO.wire('draw_chart(\'' ++ code ++ '\',' ++ x ++ ');')
    end
  end

  def event(:link_pressed), do: IO.inspect("OK!!!")

  def event(any), do: IO.inspect(any)
end
