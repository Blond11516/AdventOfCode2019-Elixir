defmodule Advent.Solvers.Day3 do
  @behaviour Advent.Solvers

  @direction_map %{"R" => :right, "U" => :up, "L" => :left, "D" => :down}

  @impl true
  def solve(1, input) do
    [cable_1, cable_2] =
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_move_list/1)
      |> Enum.map(&calculate_visited_points(&1, MapSet.new(), {0, 0}))

    MapSet.intersection(cable_1, cable_2)
    |> Enum.min_by(&mahattan_distance(&1, {0, 0}))
    |> mahattan_distance({0, 0})
  end

  defp mahattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp calculate_visited_points([], set, _current_point) do
    set
  end

  defp calculate_visited_points([first_move | other_moves], set, current_point) do
    {set, current_point} = add_points_from_move(first_move, set, current_point)
    calculate_visited_points(other_moves, set, current_point)
  end

  defp add_points_from_move({_direction, 0}, set, current_point) do
    {set, current_point}
  end

  defp add_points_from_move({direction, distance}, set, {x, y}) do
    new_point =
      case direction do
        :up -> {x, y + 1}
        :down -> {x, y - 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    set = MapSet.put(set, new_point)
    add_points_from_move({direction, distance - 1}, set, new_point)
  end

  defp parse_move_list(moves) do
    Enum.map(moves, &parse_move/1)
  end

  defp parse_move(input) do
    {parse_direction(input), parse_distance(input)}
  end

  defp parse_direction(input) do
    {:ok, direction} = Map.fetch(@direction_map, String.at(input, 0))
    direction
  end

  defp parse_distance(input) do
    {int, _} =
      String.slice(input, 1..-1)
      |> Integer.parse()

    int
  end
end
