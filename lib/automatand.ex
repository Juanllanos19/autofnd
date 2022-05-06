defmodule Automatand do
  def automatasetter([]), do: [[]]
  def automatasetter([h|t])do
    rest = automatasetter(t)
    automatasetter(h,rest,rest)
  end

  defp automatasetter(_, [], acc), do: acc
  defp automatasetter(x, [h|t], acc), do: automatasetter(x,t, [[x|h] | acc])



  def prune(n) do
    inicio = n.istate
    delta = validT(n, inicio, [], Map.new())
    |> List.flatten()
    |> merge()

    estados = Enum.map(delta, fn {{state1, _}, state2} -> [state1] ++ [state2] end)
    |> Enum.concat()
    |> Enum.uniq()
    |> Enum.sort()

    finales = Enum.filter(n.fstates, fn final -> final in estados end)
    |> Enum.uniq()

    %{%{%{n|delta: delta}|states: estados}|fstates: finales}
  end

  defp merge([]), do: Map.new()
  defp merge([h|t]) do
    Map.merge(h, merge(t))
  end

  defp validT(n, current, visited, delta) do
    visited = visited ++ [current]
    n.delta
    |> Enum.filter(fn {{child, _}, _} -> child == current end)
    |> Enum.map(fn {{current, simbolo}, susesor} ->
      if(susesor not in visited) do
        validT(n, susesor, visited, Map.put(delta, {current, simbolo}, susesor))
      else
        Map.put(delta, {current, simbolo}, susesor)
      end
    end)
  end

  def deltaput(n) do
    estados = automatasetter(n.states)
    deltav =
    for estado <- estados, transicion <- n.alpha do
      {{estado, transicion},
        Enum.map(estado, fn conjunto -> n.delta[{conjunto, transicion}] end)
        |> List.flatten
      }
    end
    {estados, deltav}
  end



  def determinize(n) do
    {estados,deltav} = deltaput(n)
    %{
      alpha: n.alpha,
      states: estados,
      istate: [n.istate],
      fstates: Enum.filter(estados, fn r -> Enum.any?(r, fn e -> e in n.fstates end) end),
      delta: deltav |> Map.new()
    }

  end

  def e_clousure(n, r) do
    #for q <- r do
      Enum.reduce(r, r, fn q, acc ->
      e_closure2(n.delta, q, acc)
    end)
    |> Enum.sort()
  end

  def e_closure2(delta, curr, stack) do
     Enum.reduce(delta[{curr, nil}] || [], stack, fn x, visitedp ->
      if x not in visitedp do
        e_closure2(delta, x, [x | visitedp])
      else
        visitedp
        #List.flatten(visitedp)
        #|> Enum.uniq
      end
    end)
  end
end
