defmodule Advent.IntcodeMachine.Executor do
  alias Advent.IntcodeMachine.Tables

  def execute("99", memory, _ip, _param_values) do
    {:terminate, memory}
  end

  def execute("01", memory, ip, [val1, val2, target]) do
    sum = (val1 + val2) |> Integer.to_string()
    execute_replace(memory, increment_ip(ip, "01"), target, sum)
  end

  def execute("02", memory, ip, [val1, val2, target]) do
    product = (val1 * val2) |> Integer.to_string()
    execute_replace(memory, increment_ip(ip, "02"), target, product)
  end

  def execute("03", memory, ip, [target]) do
    value =
      IO.gets("Enter value to insert: ")
      |> String.split("\n")
      |> hd()

    execute_replace(memory, increment_ip(ip, "03"), target, value)
  end

  def execute("04", memory, ip, [value]) do
    IO.puts("Output: #{Integer.to_string(value)}")
    {:run, memory, increment_ip(ip, "04")}
  end

  def execute("05", memory, ip, [test, jump]) do
    execute_jump(memory, increment_ip(ip, "05"), jump, test != 0)
  end

  def execute("06", memory, ip, [test, jump]) do
    execute_jump(memory, increment_ip(ip, "06"), jump, test == 0)
  end

  def execute("07", memory, ip, [left, right, target]) do
    execute_compare(memory, increment_ip(ip, "07"), target, left, right, &Kernel.</2)
  end

  def execute("08", memory, ip, [left, right, target]) do
    execute_compare(memory, increment_ip(ip, "08"), target, left, right, &Kernel.==/2)
  end

  def execute(opcode, _memory, _ip, _param_values) do
    {:error, "Invalid opcode #{opcode}."}
  end

  defp execute_replace(memory, ip, target, val) do
    memory = List.replace_at(memory, target, val)
    {:run, memory, ip}
  end

  defp execute_jump(memory, ip, jump, test) do
    ip =
      if test do
        jump
      else
        ip
      end

    {:run, memory, ip}
  end

  defp execute_compare(memory, ip, target, left, right, comparator) do
    val =
      if comparator.(left, right) do
        "1"
      else
        "0"
      end

    execute_replace(memory, ip, target, val)
  end

  defp increment_ip(ip, opcode) do
    ip + 1 + Tables.get_nb_args(opcode)
  end
end
