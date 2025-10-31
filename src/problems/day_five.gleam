import gleam/result
import gleam/int
import gleam/list
import gleam/string
import gleam/order.{type Order}
import gleam/set.{type Set}

pub fn solution() -> Int {
    let page_ordering_rule =
    "
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    "
    let printing_queue =
    "
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    " 
    solve_printing_queue(printing_queue, page_ordering_rule)
}

pub fn solve_printing_queue(input_queue: String, input_rules: String) -> Int {
    let rule_set = set_rules(input_rules)
    input_queue
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(string.trim)
    |> list.map(fn(s) { string.split(s, ",") })
    |> list.filter(keeping: fn(queue) { 
        list.sort(queue, fn(a, b) { rule_set |> ordering(a, b) }) == queue
        })
    |> list.fold(0, fn(sum, queue) { sum + get_middle_as_int(queue) })
}

fn set_rules(ordering_rule_input: String) -> Set(#(String, String)) {
    ordering_rule_input
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(string.trim)
    |> list.map(split_string_to_pair)
    |> set.from_list
}

fn split_string_to_pair(input: String) -> #(String, String) {
    let strings = string.split(input, on: "|")
    case strings {
        [first, last] -> #(first, last)
        _ -> panic as "rules should have exactly 2 parameters."
    }
}

fn ordering(rule_set: Set(#(String, String)), a: String, b: String) -> Order {
    case set.contains(rule_set, #(a, b)), set.contains(rule_set, #(b, a)) {
        True, False -> order.Lt
        False, True -> order.Gt 
        _, _ -> order.Eq
    }
}

fn get_middle_as_int(queue: List(String)) -> Int {
    let midpoint = list.length(queue) / 2
    queue
    |> list.drop(up_to: midpoint)
    |> list.first
    |> result.try(int.parse)
    |> result.unwrap(0)
}