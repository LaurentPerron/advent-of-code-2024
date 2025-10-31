import gleam/int
import gleam/list

pub fn solution() -> Int {
  let list_one = [3, 4, 2, 1, 3, 3]
  let list_two = [4, 3, 5, 3, 9, 3]
  euclidian_distance(list_one, list_two)
}

pub fn euclidian_distance(list_one: List(Int), list_two: List(Int)) -> Int {
  distance_loop(
    list.sort(list_one, int.compare),
    list.sort(list_two, int.compare),
    0,
  )
}

fn distance_loop(list_one: List(Int), list_two: List(Int), total: Int) -> Int {
  case list_one, list_two {
    [first_one, ..rest_one], [first_two, ..rest_two] ->
      distance_loop(rest_one, rest_two, total + distance(first_one, first_two))
    [first, ..rest], [] -> distance_loop(rest, list_two, total + first)
    [], [first, ..rest] -> distance_loop(list_one, rest, total + first)
    [], [] -> total
  }
}

fn distance(a: Int, b: Int) -> Int {
  int.absolute_value(a - b)
}
