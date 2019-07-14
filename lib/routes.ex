defmodule PLM.Routes do
  use N2O, with: [:n2o, :nitro]

  def finish(state, context), do: {:ok, state, context}

  def init(state, context) do
    %{path: path} = cx(context, :req)
    {:ok, state, cx(context, path: path, module: route_prefix(path))}
  end

  defp route_prefix(<<"/ws/", p::binary>>), do: route(p)
  defp route_prefix(<<"/", p::binary>>), do: route(p)
  defp route_prefix(path), do: route(path)

  def route(<<"bpe", _::binary>>), do: BPE.Index
  def route(<<"fin", _::binary>>), do: FIN.Index
  def route(<<"ldap", _::binary>>), do: LDAP.Index
  def route(<<"form", _::binary>>), do: FORM.Index
  def route(<<"act", _::binary>>), do: BPE.Actor
  def route(<<"cashflow", _::binary>>), do: PLM.Product
  def route(<<"kvs", _::binary>>), do: :kvs_adm
  def route(<<"plm", _::binary>>), do: PLM.Index
  def route(<<"app/ldap", _::binary>>), do: LDAP.Index
  def route(<<"app/form", _::binary>>), do: FORM.Index
  def route(<<"app/act", _::binary>>), do: BPE.Actor
  def route(<<"app/fin", _::binary>>), do: FIN.Index
  def route(<<"app/bpe", _::binary>>), do: BPE.Index
  def route(<<"app/kvs", _::binary>>), do: KVS.Index
  def route(<<"app/plm", _::binary>>), do: PLM.Index
  def route(<<"app/cashflow", _::binary>>), do: PLM.CashFlow
  def route(_), do: LDAP.Index
end
