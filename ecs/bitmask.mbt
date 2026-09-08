///|
struct Bitmask(UInt64) derive(Eq)

///|
pub extend Bitmask with Eq::{equal, not_equal}

///|
pub fn Bitmask::mask(x : Int) -> Bitmask {
  if x < 0 || x >= 64 {
    @tic80.abort_ascii(b"The element \{x} being masked is larger than 64")
  } else {
    Bitmask(1 << x)
  }
}

///|
pub impl BitAnd for Bitmask with fn land(a, b) {
  a.0 & b.0
}

///|
pub extend Bitmask with BitAnd::{land}

///|
pub impl BitOr for Bitmask with fn lor(a, b) {
  a.0 | b.0
}

///|
pub extend Bitmask with BitOr::{lor}

///|
pub impl BitXOr for Bitmask with fn lxor(a, b) {
  a.0 ^ b.0
}

///|
pub extend Bitmask with BitXOr::{lxor}

///|
pub fn Bitmask::contains(self : Bitmask, x : Int) -> Bool {
  (self.0 & (1 << x)) != 0
}
