defmodule Advent.IntcodeMachine.DecoderTest do
  use ExUnit.Case

  alias Advent.IntcodeMachine
  alias Advent.IntcodeMachine.{Decoder, Tables}

  test "decode/1 should expand single digit opcode to double digits" do
    machine = givenAMachineWithASingleDigitOpcode()
    {_params, opcode} = Decoder.decode(machine)
    assert opcode == '01'
  end

  test "decode/1 should return the correct number of arguments" do
    opcode = "01"
    machine = givenAMachineWithOpcode(opcode)
    {params, _opcode} = Decoder.decode(machine)
    assert length(params) == Tables.get_nb_args(String.to_charlist(opcode))
  end

  defp givenAMachineWithOpcode(opcode) do
    IntcodeMachine.new([opcode, "1", "1", "1"], 0)
  end

  defp givenAMachineWithASingleDigitOpcode do
    IntcodeMachine.new(["1", "1", "1", "1"], 0)
  end
end
