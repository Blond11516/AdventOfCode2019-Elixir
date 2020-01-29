defmodule Mix.Tasks.Advent do
  use Mix.Task

  import Advent.Input

  def run([day]) do
    run_day_part(day, "1")
  end

  def run([day, part]) do
    if !Enum.member?(["1", "2"], part) do
      IO.puts("Invalid part value: #{part}")
    else
      run_day_part(day, part)
    end
  end

  def run([]) do
    IO.puts("Missing required argument <day>")
  end

  defp run_day_part(day, part) do
    IO.puts("\nExecuting day #{day}, part #{part}\n")
    input = get_raw(day)
    part_int = Integer.parse(part) |> elem(0)
    output = apply(:"Elixir.Advent.Solvers.Day#{day}", :solve, [part_int, input])
    IO.puts("Output for day #{day}\n#{output}")
  end
end
