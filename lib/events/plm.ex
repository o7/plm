defmodule PLM.Index do
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
        panel(class: :column10, body: "Structure"),
        panel(class: :column6, body: "People"),
        panel(class: :column20, body: "Income/Outcome"),
        panel(class: :column20, body: "Control")
      ]
    )
  end

  def series(income),
    do: '[' ++ :string.join(income ++ :lists.duplicate(6 - length(income), '0'), ',') ++ ']'

  def payments(feed) do
    :lists.map(
      fn ERP."Payment"(price: {_, a2}, volume: {_, b2}) ->
        :erlang.integer_to_list(a2 * b2)
      end,
      KVS.head(feed, 6)
    )
  end

  def months() do
    {{_, x, _}, _} = :calendar.local_time()
    h1 = [:Jan, :Feb, :Mar, :Apr, :May, :Jun]
    h2 = [:Jul, :Aug, :Sep, :Oct, :Nov, :Dec]
    zip = :lists.zip(:lists.seq(1, 12), h1 ++ h2)
    {a, b} = :lists.split(x, zip)
    piz = b ++ a
    half = :lists.reverse(:lists.sublist(:lists.reverse(piz, 1), 6))
    {x, :lists.flatten(:io_lib.format("~p", [:erlang.element(2, :lists.unzip(half))]))}
  end

  def event(:init) do
    NITRO.clear(:tableRow)
    NITRO.clear(:tableHead)
    NITRO.insert_top(:tableHead, PLM.Index.header())

    for i <- KVS.feed('/plm/products') do
      code = ERP."Product"(i, :code)
      {_, scale} = months()
      income = payments('/plm/' ++ code ++ '/income')
      outcome = payments('/plm/' ++ code ++ '/outcome')
      send(self(), {:direct, {:chart, code, scale, series(income), series(outcome), i}})
    end
  end

  def event({:chart, code, x, y, z, i}) do
    NITRO.insert_bottom(:tableRow, PLM.Rows.Product.new(code, i))
    NITRO.wire(['draw_chart(\'', code, '\',', x, ',', y, ',', z, ');'])
  end

  def event({:invest, code}), do: NITRO.redirect('cashflow.htm?p=' ++ code)
  def event(_), do: []
end
