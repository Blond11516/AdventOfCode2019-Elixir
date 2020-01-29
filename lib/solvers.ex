defmodule Advent.Solvers do
  @doc "Defines the function executed when running the day's solution"
  @callback solve(part :: Integer, input :: binary()) :: any()
end
