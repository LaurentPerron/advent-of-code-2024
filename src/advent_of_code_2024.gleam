import gleam/int
import gleam/io
import problems/day_five
import problems/day_four
import problems/day_one
import problems/day_seven
import problems/day_six
import problems/day_three
import problems/day_two

pub fn main() {
  io.println("Hello from advent_of_code_2024!")
  io.println(
    "Day 1 answer is : " <> int.to_string(day_one.solution()) <> "  !!!",
  )
  io.println(
    "Day 2 answer is : " <> int.to_string(day_two.solution()) <> "   !!!",
  )
  io.println(
    "Day 3 answer is : " <> int.to_string(day_three.solution()) <> " !!!",
  )
  io.println(
    "Day 4 answer is : " <> int.to_string(day_four.solution()) <> " !!!",
  )
  io.println(
    "Day 5 answer is : " <> int.to_string(day_five.solution()) <> " !!!",
  )
  io.println(
    "Day 6 answer is : " <> int.to_string(day_six.solution()) <> " !!!",
  )
  io.println(
    "Day 7 answer is : " <> int.to_string(day_seven.solution()) <> " !!!",
  )
}
