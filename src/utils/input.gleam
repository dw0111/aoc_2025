import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read(input_file: String) {
  let raw = simplifile.read(input_file)
  assert result.is_ok(raw) as "could not read input file"
  result.unwrap(raw, "")
}

pub fn split_on_linebreak(raw: String) -> List(String) {
  string.split(raw, "\n")
}

pub fn split_on_commas(raw: String) -> List(String) {
  string.split(raw, ",")
}

pub fn make_2d_list(raw: String) {
  split_on_linebreak(raw) |> list.map(string.to_graphemes)
}
