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
    for estado <- estados, transicion <- n.alpha do
      {{estado, transicion},
        Enum.map(estado, fn conjunto -> n.delta[{conjunto, transicion}] end)
        |> List.flatten
      }
    end
  end

  def determinize(n) do
    deltav= deltaput(n)
    %{
      alpha: n.alpha,
      states: n.states,
      istate: n.istate,
      fstates: n.fstates,
      delta: deltav
    }

  end

  def e_clousure(n, r) do
    for r <- q do
      e_closure2(n.delta, r, r)
    end
  end

  def e_closure2(delta, curr, stack) do
    Enum.map(curr, fn x -> {[x], nil}end)
    |> Enun.reduce(stack, fn key, visitedp ->
      x = delta[key]
      if x != nil do
        e_closure2(delta, x, [x | visitedp])
      else
        List.flatten(visitedp)
        |> Enum.uniq
      end
    end)
  end
end
