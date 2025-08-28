import gleam/float
import gleam/int
import gleam/io
import gleam/list

import scripts/types.{type Command, type Nums, Add, Div, Mul, Round, Sort, Sub}

fn solve_pairs(nums: Nums, new_nums: Nums, command: Command) -> Nums {
  case nums {
    [first, second, ..rest] ->
      case command {
        Add -> solve_pairs(rest, [first +. second, ..new_nums], Add)
        Sub -> solve_pairs(rest, [first -. second, ..new_nums], Sub)
        Mul -> solve_pairs(rest, [first *. second, ..new_nums], Mul)
        Div -> solve_pairs(rest, [first /. second, ..new_nums], Div)
        _ -> nums
      }
    [single] -> [single, ..new_nums] |> list.reverse()
    [] -> new_nums |> list.reverse()
  }
}

pub fn do(nums: Nums, command: Command) -> Nums {
  case command {
    Sort -> list.sort(nums, float.compare)
    Round -> list.map(nums, fn(num) { float.round(num) |> int.to_float })
    _ -> solve_pairs(nums, [], command)
  }
}

pub fn all_at_once(nums: Nums, command: Command) -> Nums {
  let answer = case command {
    Add -> nums |> list.reduce(fn(acc, x) { acc +. x })
    Sub -> nums |> list.reduce(fn(acc, x) { acc -. x })
    Mul -> nums |> list.reduce(fn(acc, x) { acc *. x })
    Div -> nums |> list.reduce(fn(acc, x) { acc /. x })
    _ -> Error(Nil)
  }
  case answer {
    Ok(num) -> io.println(num |> float.to_string)
    Error(_) -> io.println("failed!")
  }
  nums
}
