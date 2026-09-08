///|
struct ResourceKey[T] {
  debug_name : String
  value : T
}

///|
pub fn[T] register_resource(debug_name : String, init : T) -> ResourceKey[T] {
  component_registry.resource_names.add(debug_name)
  { debug_name, value: init, }
}
