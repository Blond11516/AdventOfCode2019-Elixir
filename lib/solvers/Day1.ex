defmodule Advent.Solvers.Day1 do
  @behaviour Advent.Solvers

  @impl true
  def solve(part, input) do
    recursive = part == 2

    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn mass -> calculate_fuel(mass, recursive) end)
    |> Enum.sum()
  end

  defp calculate_fuel(mass, recursive) do
    fuel =
      mass
      |> div(3)
      |> Kernel.-(2)

    if fuel <= 0 do
      0
    else
      if recursive do
        fuel + calculate_fuel(fuel, true)
      else
        fuel
      end
    end
  end
end
