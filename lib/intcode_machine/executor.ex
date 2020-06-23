defmodule Advent.IntcodeMachine.Executor do
  @moduledoc """
  Executes the various instructions supported by the IntCode machine.
  """
  alias Advent.IntcodeMachine.Tables

  @type memory :: [String.t()]

  @doc """
  Executes a single instruction and returns the result.

  ## Returns

  The possible return patterns are the following :
  * `{:error, String.t()}`: The intocde machine encounterd an invalid state (typically an invalid opcode).
  Returns an error message explaining what went wrong.
  * `{:terminate, memory()}`: The IntCode machine successfully executed it's program until termination. Returns the
  machine's memory upon termination.
  * `{:run, memory(), integer()}`: The IntCode machine successfully executed an instruction and is ready to move on to
  the next one. Returns the current memory and the instruction pointer for the next instruction.
  """
  @spec execute(String.t(), memory(), integer(), [integer()]) ::
          {:error, String.t()} | {:terminate, memory()} | {:run, memory(), integer()}
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
