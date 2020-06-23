defmodule Advent.IntcodeMachine.Processor do
  @moduledoc """
  Main entry point for the IntCode machine.

  The processor receives the source file and handles the different steps of executing the corresponding program.
  """

  alias Advent.IntcodeMachine.{Decoder, Executor}

  @doc """
  Receives a source file and executes the corresponding program.

  ## Inputs

  The source file should be a text file containing a series of integers separated by commas.

  The initializer is a function that receives a list of strings (the memory) and returns another list of strings. If no
  initializer is provided, the identity function is used.

  ## Returns

  Returns one of the following :
  * `String.t()`: The IntCode machine's memory at the end of the execution. This return pattern also indicates that
  the program terminated correctly.
  * `{:error, String.t()}`: An error message indicating that something went wrong while executing the program.
  """
  @spec start(String.t(), ([String.t()] -> [String.t()])) :: [String.t()] | {:error, String.t()}
  def start(input, initializer \\ fn x -> x end) do
    input
    |> String.split(",")
    |> initializer.()
    |> run(0)
  end

  defp run(memory, ip) do
    {param_values, opcode} =
      Enum.at(memory, ip)
      |> String.to_charlist()
      |> Decoder.decode(memory, ip)

    result = Executor.execute(opcode, memory, ip, param_values)

    case result do
      {:terminate, memory} -> memory
      {:run, memory, ip} -> run(memory, ip)
      {:error, error} -> {:error, error}
    end
  end
end
