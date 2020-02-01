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
      |> Enum.map(&calculate_visited_points(&1, Map.new(), {0, 0}, 0))

    find_intersection(cable_1, cable_2)
    |> Enum.map(fn {point, _steps} -> manhattan_distance(point, {0, 0}) end)
    |> Enum.min()
  end

  @impl true
  def solve(2, input) do
    [cable_1, cable_2] =
      input
      |> String.split()
      |> Enum.map(&String.split(&1, ","))
      |> Enum.map(&parse_move_list/1)
      |> Enum.map(&calculate_visited_points(&1, Map.new(), {0, 0}, 1))

    {_closest_point, min_steps_sum} =
      find_intersection(cable_1, cable_2)
      |> Enum.min_by(fn {_points, steps} -> steps end)

    min_steps_sum
  end

  defp find_intersection(cable_1, cable_2) do
    for {point, steps_1} <- cable_1,
        Map.has_key?(cable_2, point),
        {:ok, steps_2} = Map.fetch(cable_2, point) do
      {point, steps_1 + steps_2}
    end
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  defp calculate_visited_points([], map, _current_point, _steps) do
    map
  end

  defp calculate_visited_points([first_move | other_moves], map, current_point, steps) do
    {map, current_point, steps} = add_points_from_move(first_move, map, current_point, steps)
    calculate_visited_points(other_moves, map, current_point, steps)
  end

  defp add_points_from_move({_direction, 0}, map, current_point, steps) do
    {map, current_point, steps}
  end

  defp add_points_from_move({direction, distance}, map, {x, y}, steps) do
    new_point =
      case direction do
        :up -> {x, y + 1}
        :down -> {x, y - 1}
        :left -> {x - 1, y}
        :right -> {x + 1, y}
      end

    map = Map.put_new(map, new_point, steps)
    add_points_from_move({direction, distance - 1}, map, new_point, steps + 1)
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
