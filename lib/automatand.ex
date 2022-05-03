defmodule Automatand do
  def automatasetter([]), do: [[]]
  def automatasetter([h|t])do
    rest = automatasetter(t)
    automatasetter(h,rest,rest)
  end

  defp automatasetter(_, [], acc), do: acc
  defp automatasetter(x, [h|t], acc), do: automatasetter(x,t, [[x|h] | acc])
end
