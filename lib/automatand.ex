defmodule Automatand do
  def automatasetter([]), do: [[]]
  def automatasetter([h|t])do
    rest = automatasetter(t)
    automatasetter(h,rest,rest)
  end

  defp automatasetter(_, [], acc), do: acc
  defp automatasetter(x, [h|t], acc), do: automatasetter(x,t, [[x|h] | acc])

  def determinize(n) do
    estados = automatasetter(n.states)
    for estado <- estados, transicion <- n.alpha do
    {{estado, transicion},
      Enum.map(estado, fn conjunto -> n.delta[{conjunto, transicion}] end)
      |> List.flatten
    }
    end
  end

  #def e_clousure(n, {}) do
    #
  #end
end
