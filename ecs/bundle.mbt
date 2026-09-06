///|
trait SpawnBundle {
  fn bitmask(Self) -> Bitmask
  /// Prepare the column storage for achetypes, and retures a 
  /// callback for swap and remove a row when despawning
  fn prepare(Self, archetype_id : Int) -> (Int) -> Unit
  fn append(Self, archetype_id : Int) -> Unit
}

///|
pub impl[T] SpawnBundle for ComponentEntry[T] with fn bitmask(self) {
  Bitmask::mask(self.key.id)
}

///|
pub impl[T] SpawnBundle for ComponentEntry[T] with fn prepare(
  self,
  archetype_id,
) {
  self.key.ensure(archetype_id)
  let column = self.key.get_column(archetype_id)
  // As the type of the component is erased after invoking `prepare`, the 
  // removing operation needs to be registered
  fn(row) { swap_remove_row(column, row) }
}

///|
pub impl[T] SpawnBundle for ComponentEntry[T] with fn append(self, archetype_id) {
  self.key.get_column(archetype_id).push(self.value)
}

///|
fn[T] swap_remove_row(column : Array[T], row : Int) -> Unit {
  let last = column.length() - 1
  if row != last {
    column.unsafe_set(row, column.unsafe_get(last))
  }
  column.unsafe_pop() |> ignore()
}

///|
pub extend ComponentEntry with SpawnBundle::{bitmask, prepare, append}

///|
pub impl SpawnBundle for Array[&SpawnBundle] with fn bitmask(self) {
  let mut mask = Bitmask(0)
  for bundle in self {
    mask = mask | bundle.bitmask()
  }
  mask
}

///|
pub impl SpawnBundle for Array[&SpawnBundle] with fn prepare(self, archetype_id) {
  let remove_operations = self.map(bundle => bundle.prepare(archetype_id))
  fn(row) {
    for op in remove_operations {
      op(row)
    }
  }
}

///|
pub impl SpawnBundle for Array[&SpawnBundle] with fn append(self, archetype_id) {
  for bundle in self {
    bundle.append(archetype_id)
  }
}
