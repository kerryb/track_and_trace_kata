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
  """
  def process(_people, _patient_zero) do
    []
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
    Map.put(graph, {:name, person.name}, new_place_set(person.check_ins))
  end

  defp new_place_set(check_ins) do
    check_ins
    |> Enum.map(&{:place, &1})
    |> MapSet.new()
  end

  defp map_places_to_name graph, person do
    Enum.reduce(person.check_ins, graph, &add_place_to_graph(&1, person.name, &2))
  end

  defp add_place_to_graph(place, name, graph) do
    Map.update(graph, {:place, place}, MapSet.new([{:name, name}]), &MapSet.put(&1, {:name, name}))
  end
end
