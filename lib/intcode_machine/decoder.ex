defmodule Advent.IntcodeMachine.Decoder do
  @param_modes_map %{?0 => :position, ?1 => :value}
  @nb_args_map %{
    "01" => 3,
    "02" => 3,
    "03" => 1,
    "04" => 1,
    "99" => 0
  }
  @param_dirs_map %{
    "01" => [:in, :in, :out],
    "02" => [:in, :in, :out],
    "03" => [:out],
    "04" => [:in],
    "99" => []
  }

  def decode([opcode], memory, ip, _a) do
    opcode = "0#{<<opcode::utf8>>}"
    param_modes = pad_param_modes([], opcode)
    param_values = get_param_values(param_modes, get_param_dirs(opcode), memory, ip, 0)
    {param_values, opcode}
  end

  def decode([hd | opcode], memory, ip, param_modes) when length(opcode) == 1 do
    opcode = "#{<<hd::utf8>>}#{opcode}"

    param_modes = pad_param_modes(param_modes, opcode)

    param_values = get_param_values(param_modes, get_param_dirs(opcode), memory, ip, 0)
    {param_values, opcode}
  end

  def decode([param_mode | opcode], memory, ip, param_modes) do
    {:ok, param_mode_name} = Map.fetch(@param_modes_map, param_mode)
    param_modes = [param_mode_name | param_modes]

    decode(opcode, memory, ip, param_modes)
  end

  defp pad_param_modes(param_modes, opcode) do
    {:ok, expected_args_nb} = Map.fetch(@nb_args_map, opcode)
    param_modes ++ List.duplicate(:position, expected_args_nb - length(param_modes))
  end

  defp get_value_from_memory(memory, position) do
    Enum.at(memory, position)
    |> String.to_integer()
  end

  defp get_param_dirs(opcode) do
    {:ok, dirs} = Map.fetch(@param_dirs_map, opcode)
    dirs
  end

  defp get_param_values([], [], _memory, _ip, _param_index) do
    []
  end

  defp get_param_values([:position | param_modes], [:in | param_dirs], memory, ip, param_index) do
    position = get_value_from_memory(memory, ip + 1 + param_index)

    value = get_value_from_memory(memory, position)
    [value | get_param_values(param_modes, param_dirs, memory, ip, param_index + 1)]
  end

  defp get_param_values([:position | param_modes], [:out | param_dirs], memory, ip, param_index) do
    position = get_value_from_memory(memory, ip + 1 + param_index)
    [position | get_param_values(param_modes, param_dirs, memory, ip, param_index + 1)]
  end

  defp get_param_values([:value | param_modes], [_ | param_dirs], memory, ip, param_index) do
    value = get_value_from_memory(memory, ip + 1 + param_index)
    [value | get_param_values(param_modes, param_dirs, memory, ip, param_index + 1)]
  end
end
