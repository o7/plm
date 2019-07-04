defmodule PLM.Application do
  use Application

  def start(_, _) do
    :cowboy.start_tls(:http, :n2o_cowboy.env(:plm), %{
      env: %{dispatch: :n2o_cowboy2.points()}
    })

    Supervisor.start_link([], strategy: :one_for_one, name: PLM.Supervisor)
  end
end
