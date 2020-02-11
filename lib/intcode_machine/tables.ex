defmodule Advent.IntcodeMachine.Tables do
  @param_modes_map %{?0 => :position, ?1 => :immediate}
  @nb_args_map %{
    "01" => 3,
    "02" => 3,
    "03" => 1,
    "04" => 1,
    "05" => 2,
    "06" => 2,
    "07" => 3,
    "08" => 3,
    "99" => 0
  }
  @param_dirs_map %{
    "01" => [:in, :in, :out],
    "02" => [:in, :in, :out],
    "03" => [:out],
    "04" => [:in],
    "05" => [:in, :in],
    "06" => [:in, :in],
    "07" => [:in, :in, :out],
    "08" => [:in, :in, :out],
    "99" => []
  }

  def get_param_mode(codepoint) do
    {:ok, mode} = Map.fetch(@param_modes_map, codepoint)
    mode
  end

  def get_nb_args(opcode) do
    {:ok, nb_args} = Map.fetch(@nb_args_map, opcode)
    nb_args
  end

  def get_params_dirs(opcode) do
    {:ok, params_dirs} = Map.fetch(@param_dirs_map, opcode)
    params_dirs
  end
end
