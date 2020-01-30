defmodule Advent.Solvers do
  @doc "Defines the function executed when running the day's solution"
  @callback solve(part :: 1 | 2, input :: binary()) :: any()
end
