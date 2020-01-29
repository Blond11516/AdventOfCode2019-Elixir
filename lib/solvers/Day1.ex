defmodule Advent.Solvers.Day1 do
  @behaviour Advent.Solvers

  @impl true
  def solve(part, input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calculate_fuel/1)
    |> Enum.sum()
  end

  defp calculate_fuel(mass) do
    mass
    |> div(3)
    |> Kernel.-(2)
  end
end
