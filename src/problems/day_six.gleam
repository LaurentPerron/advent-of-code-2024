import gleam/int
import gleam/order.{Lt,Eq,Gt}
import gleam/result
import gleam/list
import gleam/string
import gleam/dict.{type Dict}

pub type MapState {
    MapState(
        map: Dict(#(Int, Int), String),
        guard: #(#(Int, Int), String)
    )
}

pub fn solution() -> Int {
    let puzzle_input = "
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    "
    puzzle_input
    |> find_all_visited
}

pub fn find_final_map_state_as_string(input: String) -> String  {
    input
    |> find_final_map_state
    |> map_state_to_string
}

pub fn find_all_visited(input: String) -> Int {
    input
    |> find_final_map_state
    |> get_dict_from_map_state
    |> dict.to_list
    |> list.filter(fn(element) { element.1 == "X" })
    |> list.length
}

fn find_final_map_state(input: String) -> MapState {
    input
    |> parse_input_to_map_state
    |> find_path_to_exit
}

fn parse_input_to_map_state(input: String) -> MapState {
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.index_fold(from: MapState(dict.new(), #(#(0, 0), "")), with: fn(map_state, str, x) {
        str
        |> string.to_graphemes
        |> list.index_fold(from: map_state, with: fn(map_state, char, y) {
            case is_guard(char) {
                True -> MapState(dict.insert(map_state.map, #(x, y), char), #(#(x, y), char))
                False -> MapState(dict.insert(map_state.map, #(x, y), char), map_state.guard)
            }
        })
    })
}

fn find_path_to_exit(map_state: MapState) -> MapState {
    // Uncomment for illustration purposes
    // map_state_to_string(map_state) |> io.println
    // io.print("\n")

    let next_position = find_next_position(map_state.guard)
    let next_postion_in_dict = dict.get(map_state.map, next_position)

    case result.is_ok(next_postion_in_dict) {
        True -> map_state |> execute_action_on_next_position(#(next_position, result.unwrap(next_postion_in_dict, ""))) |> find_path_to_exit 
        False -> map_state.map |> dict.upsert(map_state.guard.0, fn(_op) { "X" }) |> MapState(map_state.guard)
    }

}

fn find_next_position(current_position: #(#(Int, Int), String)) -> #(Int, Int) {
    let #(x, y) = current_position.0
    let orientation = current_position.1
    case orientation {
        "^" -> #(x-1, y)
        "v" -> #(x+1, y)
        "<" -> #(x, y-1)
        ">" -> #(x, y+1)
        _ -> panic as "orientation not valide"
    }
}


fn execute_action_on_next_position(map_state: MapState, next: #(#(Int, Int), String)) -> MapState {
    case next {
        #(#(_x, _y), ".") | #(#(_x, _y), "X") -> 
            map_state.map |> dict.upsert(next.0, fn(_op) { map_state.guard.1 }) |> dict.upsert(map_state.guard.0, fn(_op) { "X" })
            |> MapState(#(next.0, map_state.guard.1))
        
        #(#(_x, _y), "#") -> {
            let new_guard_orientation = map_state.guard.1 |> rotate
            map_state.map |> dict.upsert(map_state.guard.0, fn(_op) { new_guard_orientation })
            |> MapState(#(map_state.guard.0, new_guard_orientation))
        }
        #(_, _) -> map_state 
    }
}

fn rotate(orientation: String) -> String {
    case orientation {
        "^" -> ">"
        "v" -> "<"
        "<" -> "^"
        ">" -> "v"
        _ -> panic as "orientation not valide"
    }
}

fn is_guard(char: String) -> Bool {
    char == "^" || char == "v" || char == "<" || char == ">"
}

fn get_dict_from_map_state(map_state: MapState) -> Dict(#(Int, Int), String) {
    map_state.map
}

fn map_state_to_string(map_state: MapState) -> String {
    get_line_numbers(map_state)
    |> list.sort(int.compare)
    |> list.map(transform_to_lines(get_dict_from_map_state(map_state)
    |> dict.to_list
    |> list.sort(by: sort_map_entry), _))
    |> string.join("\n")
}

fn get_line_numbers(map_state: MapState) {
    map_state.map
    |> dict.to_list
    |> list.map(fn(element) { element.0.0 })
    |> list.unique
}

fn transform_to_lines(li: List(#(#(Int, Int), String)), line_number: Int) {
    li
    |> list.filter(fn(element) { element.0.0 == line_number })
    |> list.map(fn(element) { element.1 })
    |> string.concat
}

fn sort_map_entry(a: #(#(Int, Int), String), b: #(#(Int, Int), String)) -> order.Order{
    let position_a = a.0
    let position_b = b.0

    case int.compare(position_a.0, position_b.0) {
        Lt -> Lt
        Gt -> Gt
        Eq -> int.compare(position_a.1, position_b.1)
    }
}