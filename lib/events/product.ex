defmodule PLM.Product do
  use N2O, with: [:n2o, :kvs, :nitro]
  use FORM, with: [:form]
  use BPE
  require Logger

  def event(:init) do
  end

  def event(any), do: IO.inspect(any)
end
