import gleam/dynamic/decode
import gleam/json
import gleam/list

import scripts/types.{type Command, type Nums, Add, Div, Mul, Sub}
import simplifile

/// does action to every number
pub fn do(nums: Nums, value: Float, command: Command) -> Nums {
  case command {
    Add -> nums |> list.map(fn(num) { num +. value })
    Sub -> nums |> list.map(fn(num) { num -. value })
    Mul -> nums |> list.map(fn(num) { num *. value })
    Div -> nums |> list.map(fn(num) { num /. value })
    _ -> nums
  }
}

/// adds new number to list
pub fn add(nums: Nums, num: Float) -> Nums {
  list.append(nums, [num])
}

/// deletes number at pos
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

pub fn save(nums: Nums, filename: String) -> Result(Nums, Nums) {
  let data =
    json.object([#("numbers", json.array(nums, json.float))])
    |> json.to_string
  let done = simplifile.write("src/" <> filename <> ".json", data)
  case done {
    Ok(_) -> Ok(nums)
    Error(_) -> Error(nums)
  }
}

pub fn load(filename: String) -> Result(Nums, Nums) {
  let data = case simplifile.read("src/" <> filename <> ".json") {
    Ok(data) -> Ok(data)
    Error(_) -> Error(Nil)
  }
  let nums_decoder = {
    use nums <- decode.field("numbers", decode.list(decode.float))
    decode.success(nums)
  }
  let data_res = case data {
    Ok(data) -> data
    Error(_) -> ""
  }
  case json.parse(data_res, nums_decoder) {
    Ok(nums) -> Ok(nums)
    Error(_) -> Error([])
  }
}
