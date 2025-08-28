import gleam/float
import gleam/io
import gleam/list
import scripts/two_arguments
import scripts/types.{type Command, type Nums, Add, Div, Exit, Mul, Sub}

fn get_by_pos(nums: Nums, pos: Int) -> Result(Float, Nil) {
  case list.drop(nums, pos - 1) {
    [first, ..] -> Ok(first)
    [] -> Error(Nil)
  }
}

fn to_command_type(command: String) -> Command {
  case command {
    "+" -> Add
    "-" -> Sub
    "*" -> Mul
    "/" -> Div
    _ -> Exit
  }
}

fn calc(
  nums: Nums,
  pos: Result(Int, Nil),
  command: Command,
  value: Float,
) -> Result(Float, Nil) {
  let pos = case pos {
    Ok(value) -> value
    Error(_) -> 0
  }
  let num = get_by_pos(nums, pos)
  case num {
    Ok(num) -> {
      case pos > 0 {
        True -> {
          case command {
            Add -> num +. value |> Ok()
            Sub -> num -. value |> Ok()
            Mul -> num *. value |> Ok()
            Div -> num /. value |> Ok()
            _ -> Error(Nil)
          }
        }
        False -> Error(Nil)
      }
    }
    Error(_) -> Error(Nil)
  }
}

pub fn show(
  nums: Nums,
  pos: Result(Int, Nil),
  command: String,
  value: Float,
) -> Nums {
  let command = to_command_type(command)
  let answer = calc(nums, pos, command, value)
  case answer {
    Ok(value) -> io.println(float.to_string(value))
    Error(_) -> io.println("Wrong position!")
  }
  nums
}

pub fn do(
  nums: Nums,
  pos: Result(Int, Nil),
  command: String,
  value: Float,
) -> Nums {
  let command = to_command_type(command)
  let answer = calc(nums, pos, command, value)
  case answer {
    Ok(value) -> two_arguments.replace(nums, pos, value)
    Error(_) -> nums
  }
}
