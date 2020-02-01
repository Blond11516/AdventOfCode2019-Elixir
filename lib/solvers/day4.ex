defmodule Advent.Solvers.Day4 do
  @behaviour Advent.Solvers

  @impl true
  def solve(1, input) do
    [{min, _}, {max, _}] =
      input
      |> String.split("-")
      |> Enum.map(&Integer.parse/1)

    valid_passwords =
      for val <- min..max,
          is_valid?(val) do
        val
      end

    length(valid_passwords)
  end

  defp is_valid?(val) do
    numbers_list =
      val
      |> Integer.to_string()
      |> String.split("", trim: true)
      |> Enum.map(&Integer.parse/1)

    has_double_digit?(numbers_list) && is_increasing?(numbers_list)
  end

  defp has_double_digit?([]), do: false

  defp has_double_digit?([_]), do: false

  defp has_double_digit?([first_num, second_num]), do: first_num == second_num

  defp has_double_digit?([first_num, second_num | rest]) do
    if first_num == second_num do
      if first_num != hd(rest) do
        true
      else
        remove_group(rest, first_num)
        |> has_double_digit?()
      end
    else
      has_double_digit?([second_num] ++ rest)
    end
  end

  defp remove_group([], _key) do
    []
  end

  defp remove_group(numbers, key) do
    if hd(numbers) == key do
      tl(numbers)
      |> remove_group(key)
    else
      numbers
    end
  end

  defp is_increasing?([_]) do
    true
  end

  defp is_increasing?([first_num | rest]) do
    if first_num > hd(rest) do
      false
    else
      is_increasing?(rest)
    end
  end
end
