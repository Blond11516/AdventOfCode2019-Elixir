defmodule Advent.IntcodeMachine.Tables do
  @moduledoc """
  Reference tables for the IntCode machine metadata.
  """

  alias Advent.IntcodeMachine

  @param_modes %{?0 => :position, ?1 => :immediate}
  @nb_args %{
    '01' => 3,
    '02' => 3,
    '03' => 1,
    '04' => 1,
    '05' => 2,
    '06' => 2,
    '07' => 3,
    '08' => 3,
    '99' => 0
  }
  @param_directions %{
    '01' => [:in, :in, :out],
    '02' => [:in, :in, :out],
    '03' => [:out],
    '04' => [:in],
    '05' => [:in, :in],
    '06' => [:in, :in],
    '07' => [:in, :in, :out],
    '08' => [:in, :in, :out],
    '99' => []
  }

  @doc """
  Get the mode of a parameter from it's intcode representation.
  """
  @spec get_param_mode(char()) :: :position | :immediate
  def get_param_mode(codepoint) do
    {:ok, mode} = Map.fetch(@param_modes, codepoint)
    mode
  end

  @doc """
  Get the number of args required by a given opcode.
  """
  @spec get_nb_args(IntcodeMachine.opcode()) :: integer()
  def get_nb_args(opcode) do
    {:ok, nb_args} = Map.fetch(@nb_args, opcode)
    nb_args
  end

  @doc """
  Get the directions of parameters for a given opcode.
  """
  @spec get_params_directions(IntcodeMachine.opcode()) :: [:in | :out]
  def get_params_directions(opcode) do
    {:ok, params_dirs} = Map.fetch(@param_directions, opcode)
    params_dirs
  end
end
