defmodule PLM.Login do
  use N2O, with: [:n2o, :nitro]
  use FORM
  require Logger

  def event(:init) do
    NITRO.clear(:stand)
    NITRO.cookie 'hello', 'world'
    NITRO.wire(api(name: 'getCookies', delegate: PLM.Login))
    mod = PLM.Forms.Pass
    NITRO.insert_bottom(:stand, FORM.new(mod.new(mod, mod.id()), mod.id()))
  end

  def event({:Next, _}), do: NITRO.redirect("plm.htm")
  def event({:SMS, _}), do: NITRO.wire("document.getCookies('sample string');")
  def event({:Close, _}), do: NITRO.redirect("index.html")
  def event(any), do: IO.inspect any

  def api_event(_,_,_), do: IO.inspect "API EVENT~n"
end
