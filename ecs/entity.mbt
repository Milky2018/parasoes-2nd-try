///|
struct Entity {
  index : Int
  generation : UInt
}

///|
pub impl Debug for Entity with fn to_repr(self) {
  @debug.Repr("\{self.index}:\{self.generation}")
}

///|
pub extend Entity with Debug::{to_repr}

///|
priv struct EntitySlot {
  mut generation : UInt
  mut location : Location?
}

///|
priv struct Location {
  archetype_id : Int
  row : Int
}
