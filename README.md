# Track and Trace

In order to combat an outbreak of ZombieVirus you've been asked by HM goverment
to implement a track and trace function that outputs a list of people's names
that need to isolate.

The function accepts two parameters:

* array of objects. Each object has a 'name' property containing the person's
  name and a 'checkIns' property that is an array of numbers that correspond to
  locations that they have visited. e.g. `{name: 'Dominic Cummings', checkIns:
  [1,5,12]}`
* a string containing the name of patient zero.

The function output is an array of names that are potentially infected. That
is, those people who have been to the same location as patient zero or someone
in contact with patient zero (at another location) and so on.

The function should not return the name of patient zero.

## Example

```elixir
TrackAndTrace.process(
  [
    %{name: "Person 1", checkIns: [1, 2, 8]},
    %{name: "Person 2", checkIns: [1, 6, 7]},
    %{name: "Person 3", checkIns: [4, 7, 9]},
    %{name: "Person 4", checkIns: [3, 5]}
  ],
  "Person 3"
)
```
Output: `["Person 1", "Person 2"]`

NOTE: the input object is shown as JSON above but you can assume it to be a
native object in whatever language you choose. Or you could assume it is a JSON
string that you can convert. You can choose.
