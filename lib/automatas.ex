defmodule Automatas do

  def a1 do
    %{
      states: [0,1,2,3],
      sigma: [?a,?b],
      delta: %{
        {0, ?a} => [0,1],
        {0, ?b} => [0],
        {1, ?a} => NILL,
        {1, ?b} => [2],
        {2, ?a} => NILL,
        {2, ?b} => [3],
        {3, ?a} => NILL,
        {3, ?b} => NILL,
      },
      q0: [0],
      f: [3]
    }
  end
end
