defmodule TrackAndTrace do
  @doc """
  Returns a list of everyone with a direct or indirect link to `patient_zero`.
  For example (NB. this is doctest, executed along with the unit tests):

      iex> TrackAndTrace.process(
      ...>   [
      ...>     %{name: "Person 1", check_ins: [1, 2, 8]},
      ...>     %{name: "Person 2", check_ins: [1, 6, 7]},
      ...>     %{name: "Person 3", check_ins: [4, 7, 9]},
      ...>     %{name: "Person 4", check_ins: [3, 5]}
      ...>   ],
      ...>   "Person 3"
      ...> )
      ["Person 1", "Person 2"]

  Disclaimer: I don't really know any graph theory, and the thing called a
  graph is really just a bidirectional map of nodes to their neighbours.
  """
  def process(people, patient_zero) do
    people
    |> build_graph()
    |> walk_graph({:name, patient_zero})
    |> get_names()
    |> Enum.sort()
  end

  # This annotation excludes the function from the module's documented public API
  @doc false
  def build_graph(data) do
    Enum.reduce(data, %{}, &add_person_to_graph/2)
  end

  defp add_person_to_graph(person, graph) do
    graph
    |> map_name_to_places(person)
    |> map_places_to_name(person)
  end

  defp map_name_to_places(graph, person) do
    Map.put(graph, {:name, person.name}, new_set_of_places(person.check_ins))
  end

  defp new_set_of_places(check_ins) do
    check_ins
    |> Enum.map(fn check_in -> {:place, check_in} end)
    |> MapSet.new()
  end

  defp map_places_to_name(graph, person) do
    Enum.reduce(person.check_ins, graph, fn check_in, graph ->
      add_place_to_graph(check_in, person.name, graph)
    end)
  end

  defp add_place_to_graph(place, name, graph) do
    Map.update(
      graph,
      # key
      {:place, place},
      # value if key not present
      MapSet.new([{:name, name}]),
      #  transform for existing value against key
      fn names -> MapSet.put(names, {:name, name}) end
    )
  end

  @doc false
  def walk_graph(graph, node) do
    walk_graph(graph, node, [node])
  end

  defp walk_graph(graph, node, found_nodes) do
    new_nodes = Enum.reject(graph[node], fn n -> n in found_nodes end)

    Enum.flat_map(new_nodes, fn neighbour ->
      [neighbour | walk_graph(graph, neighbour, found_nodes ++ new_nodes)]
    end)
  end

  defp get_names(nodes) do
    Enum.flat_map(nodes, fn
      {:name, name} -> [name]
      _ -> []
    end)
  end
end
