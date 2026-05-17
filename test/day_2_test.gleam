import day_2
import utils/input

const input_file = "./src/inputs/day_2_demo.txt"

pub fn part_1_test() {
  let raw = input.read(input_file)
  assert day_2.solve_part_1(raw) == "1227775554"
}

pub fn part_2_test() {
  let raw = input.read(input_file)
  assert day_2.solve_part_2(raw) == "4174379265"
}
