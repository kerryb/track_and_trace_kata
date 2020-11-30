defmodule TrackAndTraceTest do
  use ExUnit.Case
  doctest TrackAndTrace

  describe "TrackAndTrace/build_graph/1" do
    test "returns a map of nodes (names/places) to their directly-connected nodes" do
      assert TrackAndTrace.build_graph([
               %{name: "Alice", check_ins: [1, 2, 3]},
               %{name: "Bob", check_ins: [2, 4]}
             ]) ==
               %{
                 {:name, "Alice"} => MapSet.new([{:place, 1}, {:place, 2}, {:place, 3}]),
                 {:name, "Bob"} => MapSet.new([{:place, 2}, {:place, 4}]),
                 {:place, 1} => MapSet.new([{:name, "Alice"}]),
                 {:place, 2} => MapSet.new([{:name, "Alice"}, {:name, "Bob"}]),
                 {:place, 3} => MapSet.new([{:name, "Alice"}]),
                 {:place, 4} => MapSet.new([{:name, "Bob"}])
               }
    end
  end
  describe "TrackAndTrace/walk_graph/2" do
    test "returns directly-linked nodes" do
      graph = %{
        {:name, "Alice"} => [{:place, 1}, {:place, 2}],
        }
      assert TrackAndTrace.walk_graph(graph, {:name, "Alice"}) == [{:place, 1}, {:place, 2}]
    end
  end
end
