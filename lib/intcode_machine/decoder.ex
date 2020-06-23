defmodule Advent.IntcodeMachine.Decoder do
  @moduledoc """
  Decodes instructions from an IntCode machine's state.
  """

  alias Advent.IntcodeMachine.Tables

  @doc """
  Decodes the next instruction from the IntCode machine's state.

  Returns a tuple with the following values :
  * The list of the instruction's parameters' values
  * The instruction's opcode
  """
  @spec decode(charlist(), [String.t()], integer()) :: {[integer], binary}
  def decode(opcode, memory, ip) do
    decode(opcode, memory, ip, [])
  end

  defp decode([opcode], memory, ip, _) do
    decode([?0, opcode], memory, ip, [])
  end

  defp decode([opcode_hd, opcode_tail], memory, ip, param_modes) do
    opcode = "#{<<opcode_hd::utf8>>}#{<<opcode_tail::utf8>>}"

    param_values =
      pad_param_modes(param_modes, opcode)
      |> get_param_values(opcode, memory, ip)

    {param_values, opcode}
  end

  defp decode([param_mode | opcode], memory, ip, param_modes) do
    param_mode_name = Tables.get_param_mode(param_mode)
    param_modes = [param_mode_name | param_modes]

    decode(opcode, memory, ip, param_modes)
  end

  defp pad_param_modes(param_modes, opcode) do
    expected_args_nb = Tables.get_nb_args(opcode)
    param_modes ++ List.duplicate(:position, expected_args_nb - length(param_modes))
  end

  defp get_value_from_memory(memory, position) do
    Enum.at(memory, position)
    |> String.to_integer()
  end

  defp get_param_values(param_modes, opcode, memory, ip) do
    param_dirs = Tables.get_params_directions(opcode)
    get_param_values(param_modes, param_dirs, memory, ip, 0)
  end

  defp get_param_values([], [], _memory, _ip, _param_index) do
    []
  end

  defp get_param_values([:position | param_modes], [:in | param_dirs], memory, ip, param_index) do
    position = get_value_from_memory(memory, ip + 1 + param_index)

    value = get_value_from_memory(memory, position)
    [value | get_param_values(param_modes, param_dirs, memory, ip, param_index + 1)]
  end

  defp get_param_values([_ | param_modes], [_ | param_dirs], memory, ip, param_index) do
    position = get_value_from_memory(memory, ip + 1 + param_index)
    [position | get_param_values(param_modes, param_dirs, memory, ip, param_index + 1)]
  end
end
