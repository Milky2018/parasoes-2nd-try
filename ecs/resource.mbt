///|
struct ResourceKey[T] {
  debug_name : String
  value : T
}

///|
pub fn[T] register_resource(debug_name : String, init : T) -> ResourceKey[T] {
  { debug_name, value: init, }
}
