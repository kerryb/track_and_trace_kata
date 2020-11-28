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
end
