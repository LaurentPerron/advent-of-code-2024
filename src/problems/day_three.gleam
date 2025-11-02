import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

// On veut couper la string pour obtenir les morceaux entre les mul
// Split on mul
// Ensuite on veut identifier les bons morceaux 
// -- identifier si le premier caractère est "("
// -- rejette la string sinon
// -- identifier l'emplacement du prochain ")"
// -- Si on n'a pas de ")" on rejette
// -- Couper tout ce qui est à après avec slice
// -- Split le résultat avec ","
// -- Convertir les string avec base_parse(str, 10)
// -- Unwrap uniquement les succès
// -- Construire les pairs
// -- Évaluer et additionner
pub fn solution() -> Int {
  let problem_string =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  calculate_expression(problem_string)
}

pub fn calculate_expression(str: String) -> Int {
  parse_to_mults(str)
  |> compute
}

fn parse_to_mults(str: String) -> List(#(Int, Int)) {
  string.split(str, on: "mul(")
  |> list.filter(keeping: fn(s) { string.contains(s, ")") })
  |> list.flat_map(with: fn(s) { string.split(s, ")") })
  |> list.filter(keeping: fn(s) { string.contains(s, ",") })
  |> list.map(with: fn(s) { string.split(s, ",") })
  |> list.filter(keeping: fn(li) { list.length(li) == 2 })
  |> list.map(with: fn(list_string) { extract_pair(list_string) })
}

fn extract_pair(list_string: List(String)) -> #(Int, Int) {
  case list_string {
    [first, second] -> #(
      result.unwrap(int.base_parse(first, 10), or: 0),
      result.unwrap(int.base_parse(second, 10), or: 0),
    )
    _ -> #(0, 0)
  }
}

fn compute(mults: List(#(Int, Int))) -> Int {
  list.map(mults, with: fn(item) { pair.first(item) * pair.second(item) })
  |> list.reduce(int.add)
  |> result.unwrap(or: 0)
}
