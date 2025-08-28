import gleam/list

import scripts/types.{type Command, type Nums, Add, Div, Mul, Sub}

pub fn do(nums: Nums, value: Float, command: Command) -> Nums {
  case command {
    Add -> nums |> list.map(fn(num) { num +. value })
    Sub -> nums |> list.map(fn(num) { num -. value })
    Mul -> nums |> list.map(fn(num) { num *. value })
    Div -> nums |> list.map(fn(num) { num /. value })
    _ -> nums
  }
}

pub fn add(nums: Nums, num: Float) -> Nums {
  list.append(nums, [num])
}

pub fn del(nums: Nums, pos: Result(Int, Nil)) -> Nums {
  let pos = case pos {
    Ok(value) -> value
    Error(_) -> 0
  }
  case pos > 0 {
    True -> {
      let splitted = list.split(nums, pos - 1)
      list.append(splitted.0, splitted.1 |> list.drop(1))
    }
    False -> nums
  }
}
