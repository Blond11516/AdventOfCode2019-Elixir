defmodule Advent.IntcodeMachine do
  @moduledoc """
  An IntCode machine is represented by its internal memory and its instruction pointer.
  """

  alias Advent.IntcodeMachine.Tables

  @type memory :: [String.t()]

  @type ip :: integer()

  @type opcode :: charlist()

  @enforce_keys [:memory, :ip]
  defstruct [:memory, :ip]

  @type t :: %__MODULE__{}

  @doc """
  Creates a new IntCode machine.
  """
  @spec new(memory(), ip()) :: t()
  def new(memory, ip) do
    %__MODULE__{memory: memory, ip: ip}
  end

  @doc """
  Returns the symbol currently pointed at by the instruction pointer.
  In a correct program, this symbol will be a valid opcode.
  """
  @spec get_current_symbol(t()) :: opcode()
  def get_current_symbol(%{memory: memory, ip: ip}) do
    memory
    |> Enum.at(ip)
    |> String.to_charlist()
  end

  @doc """
  Increment the machine's instruction pointer based on `opcode`. The value by which the instruction pointer is
  incremented depends on the number of arguments `opcode` receives.
  """
  @spec increment_ip(t(), opcode()) :: t()
  def increment_ip(%{ip: ip} = machine, opcode) do
    %{machine | ip: ip + 1 + Tables.get_nb_args(opcode)}
  end

  @doc """
  Update the `machine`'s memory, writing `value` at position `index`.
  """
  @spec update_memory_at(t(), integer(), String.t()) :: t()
  def update_memory_at(%{memory: memory} = machine, index, value) do
    %{machine | memory: List.replace_at(memory, index, value)}
  end

  @doc """
  Set the `machine`'s instruction pointer to `destination`.
  """
  @spec jump(t(), ip()) :: t()
  def jump(machine, destination) do
    %{machine | ip: destination}
  end

  @doc """
  Returns the value located at position `index` in the `machine`'s memory.
  """
  @spec get_value_from_memory(t(), integer()) :: integer()
  def get_value_from_memory(%{memory: memory}, index) do
    Enum.at(memory, index)
    |> String.to_integer()
  end
end
