defmodule Advent.Solvers.Day5 do
  @behaviour Advent.Solvers

  alias Advent.IntcodeMachine.Processor

  @impl true
  def solve(1, input) do
    Processor.start(input)
    ""
  end
end
