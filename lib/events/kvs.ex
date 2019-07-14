defmodule KVS.Index do
  use N2O, with: [:n2o, :nitro]
  use FORM
  use KVS
  require ERP
  require Logger

  def parse(ERP."Employee"(person: ERP."Person"(cn: name))), do: name
  def parse(_), do: []

  def event(:init),
    do:
      [:user, :writers, :session, :enode, :disc, :ram]
      |> Enum.map(fn x -> [NITRO.clear(x), send(self(), {:direct, x})] end)

  def event(:ram), do: NITRO.update(:ram, span(body: ram(:os.type())))
  def event(:user), do: NITRO.update(:user, span(body: parse(:n2o.user())))
  def event(:session), do: NITRO.update(:session, span(body: :n2o.sid()))
  def event(:enode), do: NITRO.update(:enode, span(body: :lists.concat([:erlang.node()])))
  def event(:disc), do: NITRO.update(:disc, span(body: hd(:string.tokens(:os.cmd('du -hs rocksdb'), '\t'))))

  def event({:link, i}),
    do: [
      NITRO.clear(:feeds),
      :kvs.feed(i) |> Enum.map(fn t -> NITRO.insert_bottom(:feeds, panel(body: NITRO.compact(t))) end)
    ]

  def event(:writers),
    do:
      :writer
      |> :kvs.all()
      |> :lists.sort()
      |> Enum.map(fn writer(id: i, count: c) ->
        NITRO.insert_bottom(
          :writers,
          panel(body: [link(body: i, postback: {:link, i}), ' (' ++ NITRO.to_list(c) ++ ')'])
        )
      end)

  def event(_), do: []

  def ram({_, :darwin}) do
    mem = :os.cmd('top -l 1 -s 0 | grep PhysMem')
    [_, l, _, r] = :string.tokens(:lists.filter(fn x -> :lists.member(x, '0123456789MG ') end, mem), ' ')
    :lists.concat([NITRO.meg(NITRO.num(l)), '/', NITRO.meg(NITRO.num(l) + NITRO.num(r))])
  end

  def ram({_, :linux}) do
    [t, u, _, _, b, c] = :lists.sublist(:string.tokens(:os.cmd('free'), ' \n'), 8, 6)
    mem = :erlang.list_to_integer(u) - :erlang.list_to_integer(b) + :erlang.list_to_integer(c)
    :lists.concat([NITRO.meg(mem * 1000), '/', NITRO.meg(:erlang.list_to_integer(t) * 1000)])
  end

  def ram(os), do: NITRO.compact(os)
end
