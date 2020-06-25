defmodule Advent.IntcodeMachine.Executor do
  @moduledoc """
  Executes the various instructions supported by the IntCode machine.
  """

  alias Advent.IntcodeMachine

  @doc """
  Executes a single instruction and returns the result.

  ## Returns

  The possible return patterns are the following :
  * `{:error, String.t()}`: The intocde machine encounterd an invalid state (typically an invalid opcode).
  Returns an error message explaining what went wrong.
  * `{:terminate, IntcodeMachine.t()}`: The IntCode machine successfully executed it's program until termination. Returns the
  machine's state upon termination.
  * `{:run, IntcodeMachine.t()}`: The IntCode machine successfully executed an instruction and is ready to move on to
  the next one. Returns the current machine's state.
  """
  @spec execute(IntcodeMachine.opcode(), IntcodeMachine.t(), [integer()]) ::
          {:error, String.t()} | {:terminate, IntcodeMachine.t()} | {:run, IntcodeMachine.t()}
  def execute('99', machine, _param_values) do
    {:terminate, machine}
  end

  def execute('01' = opcode, machine, [val1, val2, target]) do
    sum = (val1 + val2) |> Integer.to_string()

    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_replace(target, sum)
  end

  def execute('02' = opcode, machine, [val1, val2, target]) do
    product = (val1 * val2) |> Integer.to_string()

    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_replace(target, product)
  end

  def execute('03' = opcode, machine, [target]) do
    value =
      IO.gets("Enter value to insert: ")
      |> String.split("\n")
      |> hd()

    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_replace(target, value)
  end

  def execute('04' = opcode, machine, [value]) do
    IO.puts("Output: #{Integer.to_string(value)}")
    machine = IntcodeMachine.increment_ip(machine, opcode)
    {:run, machine}
  end

  def execute('05' = opcode, machine, [test, jump]) do
    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_jump(jump, test != 0)
  end

  def execute('06' = opcode, machine, [test, jump]) do
    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_jump(jump, test == 0)
  end

  def execute('07' = opcode, machine, [left, right, target]) do
    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_compare(target, left, right, &Kernel.</2)
  end

  def execute('08' = opcode, machine, [left, right, target]) do
    machine
    |> IntcodeMachine.increment_ip(opcode)
    |> execute_compare(target, left, right, &Kernel.==/2)
  end

  def execute(opcode, _machine, _param_values) do
    {:error, "Invalid opcode #{opcode}."}
  end

  defp execute_replace(machine, target, val) do
    {:run, IntcodeMachine.update_memory_at(machine, target, val)}
  end

  defp execute_jump(%{ip: ip} = machine, jump, test) do
    ip =
      if test do
        jump
      else
        ip
      end

    {:run, IntcodeMachine.jump(machine, ip)}
  end

  defp execute_compare(machine, target, left, right, comparator) do
    val =
      if comparator.(left, right) do
        "1"
      else
        "0"
      end

    execute_replace(machine, target, val)
  end
end
