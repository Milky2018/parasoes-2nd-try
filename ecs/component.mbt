///|
const MAX_COMPONENTS : Int = 64

///|
priv struct Archetype {
  components : Bitmask // Bitmask of components present in this archetype
  entities : Array[Entity]
  remove_components : (Int) -> Unit
}

///|
struct ComponentKey[T] {
  id : Int // Unique identifier for the component type
  debug_name : String
  columns : Array[Array[T]?] // Data storage for each component type, indexed by archetype ID
  // columns[n] is None if the component type is not present in archetype n
}

///|
pub fn[T] ComponentKey::get_debug_name(self : ComponentKey[T]) -> String {
  self.debug_name
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
// let next_component_id : Ref[Int] = Ref(0)
let component_registry : ComponentRegistry = {
  next_component_id: 0,
  registered_names: Set([]),
}

///|
priv struct ComponentRegistry {
  mut next_component_id : Int
  registered_names : Set[String]
}

///|
pub fn[T] register_component(debug_name : String) -> ComponentKey[T] {
  guard component_registry.next_component_id < MAX_COMPONENTS else {
    @tic80.abort_ascii(
      b"The number of components is exceeding \{MAX_COMPONENTS}",
    )
  }
  guard !component_registry.registered_names.contains(debug_name) else {
    @tic80.abort_ascii(
      b"Two components are registered with the same debug_name: \{debug_name}",
    )
  }
  component_registry.registered_names.add(debug_name)
  let id = component_registry.next_component_id
  component_registry.next_component_id += 1
  { id, debug_name, columns: Array::make(8, None), }
}
