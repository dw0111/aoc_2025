import gleam/int
import gleam/io
import gleam/time/duration
import gleam/time/timestamp.{type Timestamp}

pub fn start_timer() {
  timestamp.system_time()
}

pub fn stop_timer(start_time: Timestamp) {
  let now = timestamp.system_time()
  let diff = timestamp.difference(start_time, now)
  let ms = duration.to_milliseconds(diff) |> int.to_string
  io.println("Solution ran in " <> ms <> " ms")
}
