defmodule Mix.Tasks.Advent do
  @moduledoc """
  Mix task for running the solution for a given AdventOfCode challenge.

  The task can be called as follows:
  `mix advent day [part] [--test data]`
  * day: The day for which to run the solution
  * part: The part of the day for which to run the solution. Defaults to 1.
  * --test data: Used for passing test data to the solver. If not present, the corresponding input file is used instead.
  """

  use Mix.Task

  import Advent.Input

  def run([day]) do
    run([day, "1"])
  end

  def run([day, part]) do
    if !Enum.member?(["1", "2"], part) do
      IO.puts("Invalid part value: #{part}")
    else
      run_day_part(day, part)
    end
  end

  def run([day, "--test", data]) do
    run([day, "1", "--test", String.replace(data, "\\n", "\n")])
  end

  def run([day, part, "--test", data]) do
    run_day_part(day, part, String.replace(data, "\\n", "\n"))
  end

  def run([]) do
    IO.puts("Missing required argument <day>")
  end

  defp run_day_part(day, part, data) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")
    part_int = Integer.parse(part) |> elem(0)
    output = apply(:"Elixir.Advent.Solvers.Day#{day}", :solve, [part_int, data])
    IO.puts("Output for day #{day}\n#{output}")
  end

  defp run_day_part(day, part) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")
    input = get_raw(day)
    part_int = Integer.parse(part) |> elem(0)
    output = apply(:"Elixir.Advent.Solvers.Day#{day}", :solve, [part_int, input])
    IO.puts("Output for day #{day}\n#{output}")
  end
end
