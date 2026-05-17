import day_3
import utils/input

const input_file = "./src/inputs/day_3_demo.txt"

pub fn part_1_test() {
  let raw = input.read(input_file)
  assert day_3.solve_part_1(raw) == "357"
}

pub fn part_2_test() {
  let raw = input.read(input_file)
  assert day_3.solve_part_2(raw) == "3121910778619"
}
