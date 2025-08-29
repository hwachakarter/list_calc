import gleam/float
import gleam/int
import gleam/list
import gleam/result

import scripts/misc
import scripts/one_argument
import scripts/types.{type Command, type Nums, Round}

pub fn insert(nums: Nums, pos: Result(Int, Nil), value: Float) -> Nums {
  let pos = case pos {
    Ok(value) -> value
    Error(_) -> 0
  }
  case pos > 0 {
    True -> {
      let splitted = list.split(nums, pos - 1)
      list.append(splitted.0, [value, ..splitted.1])
    }
    False -> nums
  }
}

pub fn replace(nums: Nums, pos: Result(Int, Nil), value: Float) -> Nums {
  let nums = one_argument.del(nums, pos)
  insert(nums, pos, value)
}

pub fn do(nums: Nums, pos: Result(Int, Nil), command: Command) -> Nums {
  let num = misc.get_by_pos(nums, pos |> result.unwrap(0))
  let num = case num {
    Ok(value) -> value
    Error(_) -> 0.0
  }
  case command {
    Round -> replace(nums, pos, num |> float.round |> int.to_float)
    _ -> nums
  }
}
