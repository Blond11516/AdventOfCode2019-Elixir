defmodule Advent.Solvers.Day2 do
  @behaviour Advent.Solvers

  @impl true
  def solve(1, input) do
    memory =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> initialize(12, 2)

    run(memory, 0)
  end

  @impl true
  def solve(2, input) do
    memory =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    {noun, verb} =
      for noun <- 0..99, verb <- 0..99 do
        {noun, verb}
      end
      |> Enum.find(fn {noun, verb} -> initialize(memory, noun, verb) |> run(0) == 19_690_720 end)

    100 * noun + verb
  end

  defp initialize(memory, noun, verb) do
    memory
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
  end

  defp run(memory, ip) do
    Enum.at(memory, ip)
    |> decode(memory, ip)
  end

  defp decode(99, memory, _ip) do
    Enum.at(memory, 0)
  end

  defp decode(1, memory, ip) do
    execute_op(3, memory, ip, &Kernel.+/2)
  end

  defp decode(2, memory, ip) do
    execute_op(3, memory, ip, &Kernel.*/2)
  end

  defp decode(opcode, _memory, _ip) do
    "Invalid oipode #{opcode}."
  end

  defp execute_op(3, memory, ip, fun) do
    arg1 = Enum.at(memory, ip + 1)
    arg2 = Enum.at(memory, ip + 2)
    arg3 = Enum.at(memory, ip + 3)

    List.replace_at(memory, arg3, fun.(Enum.at(memory, arg1), Enum.at(memory, arg2)))
    |> run(ip + 4)
  end
end
