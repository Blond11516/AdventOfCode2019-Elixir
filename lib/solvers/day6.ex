defmodule Advent.Solvers.Day6 do
  @behaviour Advent.Solvers

  @impl true
  def solve(_part, input) do
    input
    |> String.split()
    |> Enum.map(&String.split(&1, ")"))
    |> build_orbit_map()
    |> calculate_number_of_orbits()
  end

  defp build_orbit_map(orbits) do
    build_orbit_lists(orbits, %{})
    |> consolidate_orbit_lists()
  end

  defp build_orbit_lists([], orbit_lists) do
    orbit_lists
  end

  defp build_orbit_lists([[object, moon] | rest], orbit_lists) do
    orbit_lists = insert_orbit(object, moon, orbit_lists)
    build_orbit_lists(rest, orbit_lists)
  end

  defp insert_orbit(object, moon, orbit_lists) do
    Map.update(orbit_lists, object, [moon], fn moons -> [moon | moons] end)
  end

  defp consolidate_orbit_lists(orbit_lists) do
    root = find_root(orbit_lists)
    {root_key, root_orbits} = consolidate_orbit_lists(orbit_lists, root)
    %{root_key => root_orbits}
  end

  defp consolidate_orbit_lists(orbit_lists, {root_key, root_moons}) do
    {root_moons_orbits, other_orbits} =
      Enum.split_with(orbit_lists, fn {key, _moons} -> Enum.member?(root_moons, key) end)

    root_moons_orbits = Map.new(root_moons_orbits)

    root_moons_orbits =
      root_moons
      |> Enum.filter(fn moon -> !Enum.member?(Map.keys(root_moons_orbits), moon) end)
      |> Enum.map(fn moon -> {moon, []} end)
      |> Map.new()
      |> Map.merge(root_moons_orbits)

    root_orbits =
      for orbit <- root_moons_orbits, into: %{} do
        consolidate_orbit_lists(other_orbits, orbit)
      end

    {root_key, root_orbits}
  end

  defp find_root(orbit_lists) do
    find_root(orbit_lists, Map.to_list(orbit_lists))
  end

  defp find_root(orbit_lists, [{key, moons} | rest]) do
    if Enum.any?(orbit_lists, fn {_object, moons} -> Enum.member?(moons, key) end) do
      find_root(orbit_lists, rest)
    else
      {key, moons}
    end
  end

  defp calculate_number_of_orbits(%{} = orbit_map) do
    orbit_map
    |> Map.to_list()
    |> List.first()
    |> calculate_number_of_orbits(0)
  end

  defp calculate_number_of_orbits({_object, moons}, depth) when moons == %{} do
    depth
  end

  defp calculate_number_of_orbits({_object, moons}, depth) do
    children_orbit_count =
      moons
      |> Enum.reduce(0, fn moon, acc -> calculate_number_of_orbits(moon, depth + 1) + acc end)

    children_orbit_count + depth
  end
end
