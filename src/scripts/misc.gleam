import gleam/list

import scripts/types.{type Nums}

pub fn get_by_pos(nums: Nums, pos: Int) -> Result(Float, Nil) {
  case list.drop(nums, pos - 1) {
    [first, ..] -> Ok(first)
    [] -> Error(Nil)
  }
}
