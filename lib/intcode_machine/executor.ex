defmodule Advent.IntcodeMachine.Executor do
  def execute("99", memory, _ip, _param_values) do
    {:terminate, memory}
  end

  def execute("01", memory, ip, [val1, val2, target]) do
    sum_fn = fn list -> Enum.sum(list) |> Integer.to_string() end
    execute_replace(memory, ip, target, [val1, val2], sum_fn)
  end

  def execute("02", memory, ip, [val1, val2, target]) do
    product_fn = fn list -> Enum.reduce(list, 1, &Kernel.*/2) |> Integer.to_string() end
    execute_replace(memory, ip, target, [val1, val2], product_fn)
  end

  def execute("03", memory, ip, [target]) do
    value =
      IO.gets("Enter value to insert: ")
      |> String.split("\n")
      |> hd()

    execute_replace(memory, ip, target, [], fn _ -> value end)
  end

  def execute("04", memory, ip, [value]) do
    IO.puts("Output: #{Integer.to_string(value)}")
    {:run, memory, ip + 2}
  end

  def execute(opcode, _memory, _ip, _param_values) do
    {:error, "Invalid opcode #{opcode}."}
  end

  defp execute_replace(memory, ip, target, param_values, fun) do
    memory = List.replace_at(memory, target, fun.(param_values))
    {:run, memory, ip + length(param_values) + 2}
  end
end
