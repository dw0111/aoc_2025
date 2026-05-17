import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils/input
import utils/timer

const input_file = "./src/inputs/day_2_input.txt"

pub fn main() -> Nil {
  let raw = input.read(input_file)

  let part_1_start = timer.start_timer()
  let result_part_1 = solve_part_1(raw)
  io.println("Day 2 part 1: " <> result_part_1)
  timer.stop_timer(part_1_start)

  let part_2_start = timer.start_timer()
  let result_part_2 = solve_part_2(raw)
  io.println("Day 2 part 2: " <> result_part_2)
  timer.stop_timer(part_2_start)
}

pub fn solve_part_1(raw: String) -> String {
  let total =
    input.split_on_commas(raw)
    |> list.map(get_range)
    |> list.flat_map(get_ints_made_of_2_equal_sequences)
    |> int.sum
  int.to_string(total)
}

pub fn solve_part_2(raw: String) -> String {
  let total =
    input.split_on_commas(raw)
    |> list.map(get_range)
    |> list.flat_map(get_ints_made_entirely_of_equal_sequences)
    |> int.sum
  int.to_string(total)
}

type IdRange {
  IdRange(start: Int, end: Int)
}

fn get_range(input: String) -> IdRange {
  let #(start, end) = case string.split_once(input, "-") {
    Ok(split) -> #(int.parse(split.0), int.parse(split.1))
    Error(_) -> panic as "Range did not contain '-'"
  }
  assert result.is_ok(start) as "start of range could not be parsed into int"
  assert result.is_ok(end) as "end of range could not be parsed into int"
  IdRange(result.unwrap(start, 0), result.unwrap(end, 0))
}

fn get_ints_made_of_2_equal_sequences(range: IdRange) -> List(Int) {
  get_ints_made_of_2_equal_sequences_up_to(range.start, range.end, [])
}

fn get_ints_made_of_2_equal_sequences_up_to(
  current: Int,
  end: Int,
  extracted: List(Int),
) -> List(Int) {
  let str = int.to_string(current)
  let len = string.length(str)
  let updated_extracted = case int.is_even(len) {
    False -> extracted
    True -> {
      let is_repeating = string.ends_with(str, string.slice(str, 0, len / 2))
      case is_repeating {
        False -> extracted
        True -> [current, ..extracted]
      }
    }
  }
  case current == end {
    True -> updated_extracted
    False ->
      get_ints_made_of_2_equal_sequences_up_to(
        current + 1,
        end,
        updated_extracted,
      )
  }
}

fn get_ints_made_entirely_of_equal_sequences(range: IdRange) {
  get_ints_made_entirely_of_equal_sequences_up_to(range.start, range.end, [])
}

fn get_ints_made_entirely_of_equal_sequences_up_to(
  current: Int,
  end: Int,
  extracted: List(Int),
) -> List(Int) {
  let str = int.to_string(current)
  let len = string.length(str)
  let max_seq_len = len / 2
  let updated_extracted = case test_for_repetition_from(1, max_seq_len, str) {
    False -> extracted
    True -> [current, ..extracted]
  }

  case current == end {
    True -> updated_extracted
    False ->
      get_ints_made_entirely_of_equal_sequences_up_to(
        current + 1,
        end,
        updated_extracted,
      )
  }
}

fn test_for_repetition_from(
  seq_len: Int,
  max_seq_len: Int,
  str: String,
) -> Bool {
  let is_repeating = test_sequence(seq_len, str)
  case is_repeating, seq_len < max_seq_len {
    True, _ -> True
    False, True -> test_for_repetition_from(seq_len + 1, max_seq_len, str)
    False, False -> False
  }
}

fn test_sequence(seq_len: Int, str: String) -> Bool {
  let str_len = string.length(str)
  let is_possible = str_len > 1 && str_len % seq_len == 0
  case is_possible {
    False -> False
    True -> {
      let seq = string.slice(str, 0, seq_len)
      let repetitions = str_len / seq_len
      string.repeat(seq, repetitions) == str
    }
  }
}
