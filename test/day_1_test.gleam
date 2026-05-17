import day_1
import utils/input

const input_file = "./src/inputs/day_1_demo.txt"

pub fn part_1_test() {
  let raw = input.read(input_file)
  assert day_1.solve_part_1(raw) == "3"
}

pub fn part_2_test() {
  let raw = input.read(input_file)
  assert day_1.solve_part_2(raw) == "6"
}
