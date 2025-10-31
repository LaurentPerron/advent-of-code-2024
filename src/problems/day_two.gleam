import gleam/int
import gleam/list

const maximum_deviation = 3

pub fn solution() -> Int {
  let reports = [
  [7, 6, 4, 2, 1],
  [1, 2, 7, 8, 9],
  [9, 7, 6, 2, 1],
  [1, 3, 2, 4, 5],
  [8, 6, 4, 4, 1],
  [1, 3, 6, 7, 9],
  ]
  get_amount_of_safe_reports(0, reports)
}

fn get_amount_of_safe_reports(total: Int, reports: List(List(Int))) -> Int {
  case reports {
    [first, ..rest] ->
    get_initial_direction(first)
    |> is_report_safe(first, True)
    |> get_increment
    |> int.add(total)
    |> get_amount_of_safe_reports(rest)
    [] -> total
  }
}

fn is_report_safe(direction: fn(Int, Int) -> Bool, report: List(Int), is_safe: Bool) -> Bool {
  case report, is_safe {
    [first, second, ..rest], True -> is_report_safe(direction, list.append([second], rest), is_variation_safe(first, second, direction))
    [_], True -> True
    [], True -> True
    _, False -> False
  }
}

fn is_variation_safe(current: Int, next: Int, direction: fn(Int, Int) -> Bool) -> Bool {
  direction(current, next) && int.absolute_value(current - next) <= maximum_deviation
}

fn get_increment(bool: Bool) -> Int {
  case bool {
    True -> 1
    False -> 0
  }
}

fn get_initial_direction(report: List(Int)) -> fn(Int, Int) -> Bool {
  case report {
    [first, second, ..]  if first >= second -> fn(current, next) { current > next }
    [first, second, ..]  if first < second -> fn(current, next) { current < next }
    [_, _, ..] -> panic as "Initial direction is neither up nor down"
    [_] -> panic as "List does not contain enough entries to evaluate direction"
    [] -> panic as "List does not contain enough entries to evaluate direction"
  }
}
