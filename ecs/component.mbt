///|
priv struct Archetype {
  components : Bitmask // Bitmask of components present in this archetype
  entities : Array[Entity]
  remove_components : (Int) -> Unit
}

///|
struct ComponentKey[T] {
  id : Int // Unique identifier for the component type
  _debug_name : String
  columns : Array[Array[T]?] // Data storage for each component type, indexed by archetype ID
  // columns[n] is None if the component type is not present in archetype n
}

///|
struct ComponentEntry[T] {
  key : ComponentKey[T]
  value : T
}

///|
pub fn[T] ComponentKey::entry(
  self : ComponentKey[T],
  value : T,
) -> ComponentEntry[T] {
  { key: self, value, }
}

///|
pub fn[T] ComponentKey::ensure(
  self : ComponentKey[T],
  archetype_id : Int,
) -> Unit {
  let columns = self.columns
  if columns.length() <= archetype_id {
    columns.resize(archetype_id + 1, None)
  }
  columns[archetype_id] = Some(Array(capacity=8))
}

///|
/// Call this function when you make sure this component is present in an 
/// archetype by `ComponentKey::ensure`
pub fn[T] ComponentKey::get_column(
  self : ComponentKey[T],
  archetype_id : Int,
) -> Array[T] {
  match self.columns.get(archetype_id) {
    Some(Some(column)) => column
    _ =>
      @tic80.abort_ascii(
        b"component #\{self.id} is absent from archetype #\{archetype_id}",
      )
  }
}

///|
let next_component_id : Ref[Int] = Ref(0)

///|
pub fn[T] register_component(debug_name : String) -> ComponentKey[T] {
  let id = next_component_id.val
  next_component_id.val += 1
  { id, _debug_name: debug_name, columns: Array::make(8, None), }
}
