import problems/day_seven
import gleeunit
import problems/day_one
import problems/day_two
import problems/day_three
import problems/day_four
import problems/day_five
import problems/day_six

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn day_one_test() {
  assert day_one.solution() == 11 as "Answer should be 11 !!"
}

pub fn day_two_test() {
  assert day_two.solution() == 2 as "Answer should be 2 !!"
}

pub fn day_three_test() {
  assert day_three.solution() == 161 as "Answer should be 161 !!"
}

pub fn day_four_test() {
  assert day_four.solution() == 18 as "Answer should be 18 !!"
}

pub fn day_five_test() {
  assert day_five.solution() == 143 as "Answer should be 143 !!"
}

pub fn day_six_test() {
  assert day_six.solution() == 41 as "Answer should be 41 !!"
}

pub fn day_seven_test() {
  assert day_seven.solution() == 3749 as "Answer should be 3749 !!"
}