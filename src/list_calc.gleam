// basic imports
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

// other inputs
import argv
import input
import scripts/one_argument
import scripts/single_commands
import scripts/three_arguments
import scripts/two_arguments
import scripts/types.{type Nums, Add, Div, Exit, Mul, Round, Sort, Sub, Tors}

/// Accepts string and returns float
fn inp_to_float(inp: String) -> Float {
  float.parse(inp)
  // if parsing float failed, tries to parse as integer
  // if fails again, defaults to 0 and turns to float
  |> result.unwrap(int.parse(inp) |> result.unwrap(0) |> int.to_float())
}

/// prints out the list
fn print_nums(nums: Nums) -> Nil {
  io.print("[")
  // maps all numbers to strings, joins them and prints out
  list.map(nums, fn(x) { float.to_string(x) })
  |> string.join(", ")
  |> io.print()
  io.println("]")
}

/// Clears the terminal
fn terminal_clear() {
  // this uses escape characters
  io.print("\u{001b}[1J\u{001b}[H")
}

/// runs recursively and adds user's input until gets an empty string
fn input_all(nums: Nums) -> Nums {
  let inp =
    input.input("Enter a number (nothing to finish): ") |> result.unwrap("")
  case inp {
    // if got an empty string, return nums
    "" -> nums
    // adds a num and runs again
    _ -> input_all(list.append(nums, [inp_to_float(inp)]))
  }
}

/// prints nums and runs recursively until gets false
fn parsing(nums: Nums) {
  print_nums(nums)
  case get_command(nums) {
    #(nums, True) -> parsing(nums)
    #(_, False) -> io.println("Goodbye!")
  }
}

/// gets user's input and runs needed command
fn get_command(nums: Nums) -> #(Nums, Bool) {
  // if fails to get input exits the program
  let inp = input.input("> ") |> result.unwrap("exit") |> string.split(" ")
  case inp {
    // if inp has only one item
    [single] ->
      case single {
        // double actions
        "++" -> #(single_commands.do(nums, Add), True)
        "--" -> #(single_commands.do(nums, Sub), True)
        "**" -> #(single_commands.do(nums, Mul), True)
        "//" -> #(single_commands.do(nums, Div), True)

        // word commands
        "sort" -> #(single_commands.do(nums, Sort), True)
        "tors" -> #(single_commands.do(nums, Tors), True)
        "round" -> #(single_commands.do(nums, Round), True)
        "clear" -> {
          terminal_clear()
          #(nums, True)
        }
        "empty" -> #([], True)
        "exit" -> #(single_commands.do(nums, Exit), False)

        // triple actions
        "+++" -> #(single_commands.all_at_once(nums, Add), True)
        "---" -> #(single_commands.all_at_once(nums, Sub), True)
        "***" -> #(single_commands.all_at_once(nums, Mul), True)
        "///" -> #(single_commands.all_at_once(nums, Div), True)

        // failsafe
        _ -> #(nums, True)
      }
    // two items
    [first, second] ->
      case first {
        // actions
        "+" -> #(one_argument.do(nums, inp_to_float(second), Add), True)
        "-" -> #(one_argument.do(nums, inp_to_float(second), Sub), True)
        "*" -> #(one_argument.do(nums, inp_to_float(second), Mul), True)
        "/" -> #(one_argument.do(nums, inp_to_float(second), Div), True)

        // word commands
        "add" -> #(one_argument.add(nums, inp_to_float(second)), True)
        "del" -> #(one_argument.del(nums, int.parse(second)), True)
        "save" -> {
          case one_argument.save(nums, second) {
            Ok(nums) -> #(nums, True)
            Error(nums) -> {
              io.println("Something gone wrong!")
              #(nums, True)
            }
          }
        }
        "load" -> {
          case one_argument.load(second) {
            Ok(nums) -> #(nums, True)
            Error(_) -> {
              io.println("File not found!")
              #(nums, True)
            }
          }
        }

        // failsafe
        _ -> #(nums, True)
      }
    // three items
    [first, second, third] ->
      case first {
        "insert" -> #(
          two_arguments.insert(nums, int.parse(second), inp_to_float(third)),
          True,
        )
        "replace" -> #(
          two_arguments.replace(nums, int.parse(second), inp_to_float(third)),
          True,
        )
        "do" ->
          case third {
            "round" -> #(two_arguments.do(nums, int.parse(second), Round), True)
            _ -> #(nums, True)
          }
        _ -> #(nums, True)
      }
    // four items
    [first, second, third, fourth] ->
      case first {
        "show" -> #(
          three_arguments.show(
            nums,
            int.parse(second),
            third,
            inp_to_float(fourth),
          ),
          True,
        )
        "do" -> #(
          three_arguments.do(
            nums,
            int.parse(second),
            third,
            inp_to_float(fourth),
          ),
          True,
        )
        // failsafe
        _ -> #(nums, True)
      }
    // failsafe
    _ -> #(nums, True)
  }
}

pub fn main() {
  io.println("Hello from list_calc!")
  // check for arguments and make a list out of them if present
  let nums = case argv.load().arguments {
    [_, ..] -> list.map(argv.load().arguments, inp_to_float)
    [] -> input_all([])
  }
  parsing(nums)
}
