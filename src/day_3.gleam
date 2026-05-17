import gleam/int
import gleam/io
import gleam/list
import gleam/string
import utils/input
import utils/timer

const input_file = "./src/inputs/day_3_input.txt"

pub fn main() -> Nil {
  let raw = input.read(input_file)

  let part_1_start = timer.start_timer()
  let result_part_1 = solve_part_1(raw)
  io.println("Day 3 part 1: " <> result_part_1)
  timer.stop_timer(part_1_start)

  let part_2_start = timer.start_timer()
  let result_part_2 = solve_part_2(raw)
  io.println("Day 3 part 2: " <> result_part_2)
  timer.stop_timer(part_2_start)
}

pub fn solve_part_1(raw: String) -> String {
  let batteries = input.make_2d_list(raw)
  let joltages = list.map(batteries, find_max_joltage_with_2)
  int.to_string(int.sum(joltages))
}

pub fn solve_part_2(raw: String) -> String {
  let batteries = input.make_2d_list(raw)
  let joltages = list.map(batteries, find_max_joltage_with_12)
  int.to_string(int.sum(joltages))
}

fn find_max_joltage_with_2(bank: List(String)) -> Int {
  let combinations =
    list.combinations(bank, 2)
    |> list.map(string.join(_, ""))
    |> list.try_map(int.parse)
  let combinations = case combinations {
    Ok(c) -> c
    Error(_) -> panic as "could not parse combinations to int"
  }
  use max, current <- list.fold(combinations, 0)
  case current > max {
    True -> current
    False -> max
  }
}

fn find_max_joltage_with_12(bank: List(String)) -> Int {
  let bank = list.try_map(bank, int.parse)
  let bank = case bank {
    Ok(c) -> c
    Error(_) -> panic as "could not parse combinations to int"
  }
  combine_12_highest(bank)
}

fn combine_12_highest(bank: List(Int)) -> Int {
  let min_remaining = 11
  let max_joltage =
    get_highest_12_digit_combo(bank, min_remaining, [])
    |> list.map(int.to_string)
    |> string.join("")
    |> int.parse

  case max_joltage {
    Ok(joltage) -> joltage
    Error(_) -> panic as "unable to combine 12 highest"
  }
}

fn get_highest_12_digit_combo(
  bank: List(Int),
  min_remaining: Int,
  max_nrs: List(Int),
) {
  case list.length(max_nrs) {
    12 -> list.reverse(max_nrs)
    _ -> {
      let indexed_bank = add_idx_to_values(bank)
      let win_len = list.length(bank) - min_remaining
      let #(max, idx) = get_first_max_in_window(indexed_bank, win_len)
      get_highest_12_digit_combo(list.drop(bank, idx + 1), min_remaining - 1, [
        max,
        ..max_nrs
      ])
    }
  }
}

fn get_first_max_in_window(bank: List(#(Int, Int)), win_len: Int) {
  let window = list.take(bank, win_len)
  case list.max(window, fn(a, b) { int.compare(a.0, b.0) }) {
    Ok(max) -> max
    Error(_) -> panic as "could not extract max from list"
  }
}

fn add_idx_to_values(input: List(a)) {
  list.index_map(input, fn(v, i) { #(v, i) })
}
