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

  defp calculate_fuel(mass, false) do
    mass
    |> div(3)
    |> Kernel.-(2)
  end

  defp calculate_fuel(mass, true) do
    fuel = calculate_fuel(mass, false)

    if fuel <= 0 do
      0
    else
      fuel + calculate_fuel(fuel, true)
    end
  end
end
