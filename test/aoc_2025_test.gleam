import argv
import day_1_test
import day_2_test
import day_3_test
import gleam/io
import gleeunit

pub fn main() -> Nil {
  case argv.load().arguments {
    [] -> gleeunit.main()
    ["1"] -> {
      day_1_test.part_1_test()
      day_1_test.part_2_test()
      print_success_msg("2")
    }
    ["2"] -> {
      day_2_test.part_1_test()
      day_2_test.part_2_test()
      print_success_msg("2")
    }
    ["3"] -> {
      day_3_test.part_1_test()
      day_3_test.part_2_test()
      print_success_msg("2")
    }
    _ -> panic as "unknown day"
  }
}

fn print_success_msg(name: String) {
  io.println("\u{001b}[32m" <> name <> " passed")
}
