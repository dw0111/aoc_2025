import gleam/int
import gleam/io
import gleam/list
import gleam/string
import utils/input
import utils/timer

const input_file = "./src/inputs/day_1_input.txt"

const start_pos = 50

pub fn main() -> Nil {
  let raw = input.read(input_file)

  let part_1_start = timer.start_timer()
  let result_part_1 = solve_part_1(raw)
  io.println("Day 1 part 1: " <> result_part_1)
  timer.stop_timer(part_1_start)

  let part_2_start = timer.start_timer()
  let result_part_2 = solve_part_2(raw)
  io.println("Day 1 part 2: " <> result_part_2)
  timer.stop_timer(part_2_start)
}

pub fn solve_part_1(raw: String) -> String {
  let rotations = input.split_on_linebreak(raw) |> list.map(split_rotation)
  let zero_count = count_zeros_at_end_of_turn(start_pos, rotations, 0)
  int.to_string(zero_count)
}

pub fn solve_part_2(raw: String) -> String {
  let rotations = input.split_on_linebreak(raw) |> list.map(split_rotation)
  let zero_count = count_zeros_during_turning(start_pos, rotations, 0)
  int.to_string(zero_count)
}

type Rotation {
  Left(clicks: Int)
  Right(clicks: Int)
}

fn split_rotation(rotation: String) -> Rotation {
  let trimmed = string.trim(rotation)

  let direction = string.slice(trimmed, 0, 1) |> string.uppercase()
  let clicks = case string.drop_start(trimmed, 1) |> int.parse() {
    Ok(clicks) -> clicks
    Error(_) -> panic as "clicks could not be parsed into int"
  }

  case direction {
    "L" -> Left(clicks)
    "R" -> Right(clicks)
    _ -> panic as "unknown direction found"
  }
}

fn count_zeros_at_end_of_turn(
  pos: Int,
  rotations: List(Rotation),
  zero_count: Int,
) -> Int {
  let updated_zero_count = case pos {
    0 -> zero_count + 1
    _ -> zero_count
  }
  case rotations {
    [] -> updated_zero_count
    [r, ..rest] ->
      turn_dial(pos, r) |> count_zeros_at_end_of_turn(rest, updated_zero_count)
  }
}

fn turn_dial(pos: Int, rotation: Rotation) {
  case rotation {
    Left(clicks) -> turn_dial_left(pos, clicks)
    Right(clicks) -> turn_dial_right(pos, clicks)
  }
}

fn turn_dial_left(pos: Int, clicks: Int) -> Int {
  let new_pos = pos - clicks % 100
  case new_pos < 0 {
    False -> new_pos
    True -> 100 - int.absolute_value(new_pos)
  }
}

fn turn_dial_right(pos: Int, clicks: Int) -> Int {
  { pos + clicks } % 100
}

fn count_zeros_during_turning(
  pos: Int,
  rotations: List(Rotation),
  zero_count: Int,
) -> Int {
  case rotations {
    [] -> zero_count
    [r, ..rest] -> {
      let new_count = zero_count + count_zeros(pos, r)
      let new_pos = turn_dial(pos, r)
      count_zeros_during_turning(new_pos, rest, new_count)
    }
  }
}

fn count_zeros(pos: Int, rotation: Rotation) -> Int {
  case rotation {
    Left(clicks) -> count_zeros_turning_left(pos, clicks)
    Right(clicks) -> count_zeros_turning_right(pos, clicks)
  }
}

fn count_zeros_turning_left(pos: Int, clicks: Int) -> Int {
  let additional_zero = case pos {
    0 -> 0
    _ -> 1
  }
  case { pos - clicks } <= 0 {
    True -> additional_zero + { clicks - pos } / 100
    False -> 0
  }
}

fn count_zeros_turning_right(pos: Int, clicks: Int) -> Int {
  { pos + clicks } / 100
}
