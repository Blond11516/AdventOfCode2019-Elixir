defmodule Advent.Solvers.Day2 do
  @behaviour Advent.Solvers

  @impl true
  def solve(_part, input) do
    memory =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.replace_at(1, 12)
      |> List.replace_at(2, 2)

    run(memory, 0)
  end

  defp run(memory, pc) do
    Enum.at(memory, pc)
    |> decode(memory, pc)
  end

  defp decode(99, memory, _pc) do
    Enum.at(memory, 0)
  end

  defp decode(1, memory, pc) do
    execute_op(3, memory, pc, &Kernel.+/2)
  end

  defp decode(2, memory, pc) do
    execute_op(3, memory, pc, &Kernel.*/2)
  end

  defp decode(opcode, _memory, _pc) do
    "Invalid opcode #{opcode}."
  end

  defp execute_op(3, memory, pc, fun) do
    arg1 = Enum.at(memory, pc + 1)
    arg2 = Enum.at(memory, pc + 2)
    arg3 = Enum.at(memory, pc + 3)

    List.replace_at(memory, arg3, fun.(Enum.at(memory, arg1), Enum.at(memory, arg2)))
    |> run(pc + 4)
  end
end
