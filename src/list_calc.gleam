import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

import input
import scripts/single_commands

import scripts/types.{type Nums, Add, Div, Exit, Mul, Sort, Sub}

fn inp_to_float(inp: String) -> Float {
  float.parse(inp)
  |> result.unwrap(int.parse(inp) |> result.unwrap(0) |> int.to_float())
}

fn print_nums(nums: Nums) -> Nil {
  io.print("[")
  list.map(nums, fn(x) { float.to_string(x) })
  |> string.join(", ")
  |> io.print()
  io.println("]")
}

fn input_all(nums: Nums) -> Nums {
  let inp =
    input.input("Enter a number (nothing to finish): ") |> result.unwrap("")
  case inp {
    "" -> nums
    _ -> input_all(list.append(nums, [inp_to_float(inp)]))
  }
}

fn parsing(nums: Nums) {
  print_nums(nums)
  case get_command(nums) {
    #(nums, True) -> parsing(nums)
    #(_, False) -> io.println("Goodbye!")
  }
}

fn get_command(nums: Nums) -> #(Nums, Bool) {
  let inp = input.input("> ") |> result.unwrap("exit") |> string.split(" ")
  case inp {
    [single] ->
      case single {
        "++" -> #(single_commands.do_single(nums, Add), True)
        "--" -> #(single_commands.do_single(nums, Sub), True)
        "**" -> #(single_commands.do_single(nums, Mul), True)
        "//" -> #(single_commands.do_single(nums, Div), True)

        "sort" -> #(single_commands.do_single(nums, Sort), True)
        "exit" -> #(single_commands.do_single(nums, Exit), False)

        "+++" -> #(single_commands.all_at_once(nums, Add), True)
        "---" -> #(single_commands.all_at_once(nums, Sub), True)
        "***" -> #(single_commands.all_at_once(nums, Mul), True)
        "///" -> #(single_commands.all_at_once(nums, Div), True)
        _ -> #(nums, True)
      }
    _ -> #(nums, True)
  }
}

pub fn main() {
  io.println("Hello from list_calc!")
  let nums = input_all([])
  parsing(nums)
}
