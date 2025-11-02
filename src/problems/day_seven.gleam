import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Tree {
  Node(data: Int, left: Tree, right: Tree)
  Nil
}

pub type Puzzle {
  Puzzle(solution: Int, equations: Tree)
}

pub fn solution() -> Int {
  let puzzle_input =
    "
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    "
  puzzle_input
  |> sum_all_solvable_equations
}

pub fn sum_all_solvable_equations(input: String) -> Int {
  input
  |> input_as_puzzles
  |> list.fold(0, fn(acc, puzzle) { acc + solve_puzzle(puzzle) })
}

fn input_as_puzzles(input: String) -> List(Puzzle) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.map(build_puzzle_line)
}

fn solve_puzzle(puzzle: Puzzle) -> Int {
  case is_solvable(0, puzzle.solution, puzzle.equations, int.add) {
    True -> puzzle.solution
    False -> 0
  }
}

fn build_puzzle_line(line: String) -> Puzzle {
  case string.split(line, ":") {
    [first, rest] ->
      Puzzle(first |> int.parse |> result.unwrap(0), rest |> build_tree)
    _ -> panic as "list should not be of other format"
  }
}

fn build_tree(str: String) -> Tree {
  str
  |> string.trim
  |> string.split(" ")
  |> list.map(fn(operand) { operand |> int.parse |> result.unwrap(0) })
  |> list.fold(Nil, insert)
}

fn insert(tree: Tree, data: Int) -> Tree {
  case tree {
    Node(tree_data, left, right) ->
      Node(tree_data, insert(left, data), insert(right, data))
    Nil -> Node(data, Nil, Nil)
  }
}

fn is_solvable(
  acc: Int,
  expected: Int,
  tree: Tree,
  operation: fn(Int, Int) -> Int,
) -> Bool {
  case tree {
    Node(tree_data, left, right) ->
      is_solvable(operation(acc, tree_data), expected, left, int.add)
      || is_solvable(operation(acc, tree_data), expected, right, int.multiply)
    Nil -> acc == expected
  }
}
