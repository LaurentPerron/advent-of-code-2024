import gleam/dict.{type Dict, get}
import gleam/list
import gleam/string

pub fn solution() -> Int {
  let input_string =
    "
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    "
  find_all_xmas(input_string)
}

pub fn find_all_xmas(input: String) -> Int {
  let word_search = parse_word_search(input)
  dict.fold(word_search, 0, fn(count, position, char) {
    case char {
      "X" -> count + xmas_search(position, word_search)
      _ -> count
    }
  })
}

fn parse_word_search(input: String) -> Dict(#(Int, Int), String) {
  input
  |> string.trim()
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.index_fold(dict.new(), fn(dictionary, line, x) {
    string.to_graphemes(line)
    |> list.index_fold(dictionary, fn(dictionary, char, y) {
      dict.insert(dictionary, #(x, y), char)
    })
  })
}

fn xmas_search(position: #(Int, Int), ws: Dict(#(Int, Int), String)) -> Int {
  let #(x, y) = position
  let search_space = [
    #(#(x, y - 1), #(x, y - 2), #(x, y - 3)),
    #(#(x - 1, y), #(x - 2, y), #(x - 3, y)),
    #(#(x, y + 1), #(x, y + 2), #(x, y + 3)),
    #(#(x + 1, y), #(x + 2, y), #(x + 3, y)),
    #(#(x - 1, y - 1), #(x - 2, y - 2), #(x - 3, y - 3)),
    #(#(x + 1, y - 1), #(x + 2, y - 2), #(x + 3, y - 3)),
    #(#(x - 1, y + 1), #(x - 2, y + 2), #(x - 3, y + 3)),
    #(#(x + 1, y + 1), #(x + 2, y + 2), #(x + 3, y + 3)),
  ]
  search_space
  |> list.fold(0, fn(count, direction) {
    let #(letter_m, letter_a, letter_s) = direction
    case get(ws, letter_m), get(ws, letter_a), get(ws, letter_s) {
      Ok("M"), Ok("A"), Ok("S") -> count + 1
      _, _, _ -> count
    }
  })
}
