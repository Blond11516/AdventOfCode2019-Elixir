defmodule Advent.IntcodeMachine.Processor do
  alias Advent.IntcodeMachine.{Decoder, Executor}

  @spec start(binary, ([String.t()] -> [String.t()])) :: any
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
