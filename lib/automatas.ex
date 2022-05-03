defmodule Automatas do

  def a1 do
    %{
      alpha: ~w[a b],
      states: [P0,P1,P2,P3],
      istate: P0,
      fstates: [P3],
      delta: %{
        {P0, "a"} => [P0,P1],
        {P0, "b"} => [P0],
        {P1, "a"} => [],
        {P1, "b"} => [P2],
        {P2, "a"} => [],
        {P2, "b"} => [P3],
        {P3, "a"} => [],
        {P3, "b"} => [],
      }
    }
  end
end
