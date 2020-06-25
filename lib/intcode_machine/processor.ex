defmodule Advent.IntcodeMachine.Processor do
  @moduledoc """
  Main entry point for the IntCode machine.

  The processor receives the source file and handles the different steps of executing the corresponding program.
  """

  alias Advent.IntcodeMachine
  alias Advent.IntcodeMachine.{Decoder, Executor}

  @doc """
  Receives a source file and executes the corresponding program.

  ## Inputs

  The source file should be a text file containing a series of integers separated by commas.

  The initializer is a function that receives a list of strings (the memory) and returns another list of strings. If no
  initializer is provided, the identity function is used.

  ## Returns

  Returns one of the following :
  * `IntcodeMachine.t()`: The IntCode machine's state at the end of the execution. This return pattern also indicates that
  the program terminated correctly.
  * `{:error, String.t()}`: An error message indicating that something went wrong while executing the program.
  """
  @spec start(String.t(), ([String.t()] -> [String.t()])) :: IntcodeMachine.t() | {:error, String.t()}
  def start(input, initializer \\ fn x -> x end) do
    input
    |> String.split(",")
    |> initializer.()
    |> IntcodeMachine.new(0)
    |> run()
  end

  defp run(machine) do
    {param_values, opcode} = Decoder.decode(machine)

    result = Executor.execute(opcode, machine, param_values)

    case result do
      {:terminate, machine} -> machine
      {:run, machine} -> run(machine)
      {:error, error} -> {:error, error}
    end
  end
end
