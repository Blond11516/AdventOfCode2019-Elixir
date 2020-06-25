defmodule Advent.IntcodeMachine.Decoder do
  @moduledoc """
  Decodes instructions from an IntCode machine's state.
  """

  alias Advent.IntcodeMachine
  alias Advent.IntcodeMachine.Tables

  @doc """
  Decodes the next instruction from the IntCode machine's state.

  Returns a tuple with the following values :
  * The list of the instruction's parameters' values
  * The instruction's opcode
  """
  @spec decode(IntcodeMachine.t()) :: {[integer], IntcodeMachine.opcode()}
  def decode(machine) do
    IntcodeMachine.get_current_symbol(machine)
    |> decode(machine, [])
  end

  # Opcode is single digit, need to pad with '0'
  defp decode([opcode], machine, _) do
    decode([?0, opcode], machine, [])
  end

  # Only opcode remains
  defp decode(opcode, machine, param_modes) when length(opcode) == 2 do
    param_values =
      param_modes
      |> pad_param_modes(opcode)
      |> get_param_values(opcode, machine)

    {param_values, opcode}
  end

  # Parameter modes left to decode
  defp decode([param_mode | opcode], machine, param_modes) do
    param_mode_name = Tables.get_param_mode(param_mode)
    param_modes = [param_mode_name | param_modes]

    decode(opcode, machine, param_modes)
  end

  defp pad_param_modes(param_modes, opcode) do
    expected_args_nb = Tables.get_nb_args(opcode)
    param_modes ++ List.duplicate(:position, expected_args_nb - length(param_modes))
  end

  defp get_param_values(param_modes, opcode, machine) do
    param_dirs = Tables.get_params_directions(opcode)
    get_param_values(param_modes, param_dirs, machine, 0)
  end

  defp get_param_values([], [], _machine, _param_index) do
    []
  end

  defp get_param_values([:position | param_modes], [:in | param_dirs], %{ip: ip} = machine, param_index) do
    position = IntcodeMachine.get_value_from_memory(machine, ip + 1 + param_index)

    value = IntcodeMachine.get_value_from_memory(machine, position)
    [value | get_param_values(param_modes, param_dirs, machine, param_index + 1)]
  end

  defp get_param_values([_ | param_modes], [_ | param_dirs], %{ip: ip} = machine, param_index) do
    position = IntcodeMachine.get_value_from_memory(machine, ip + 1 + param_index)
    [position | get_param_values(param_modes, param_dirs, machine, param_index + 1)]
  end
end
