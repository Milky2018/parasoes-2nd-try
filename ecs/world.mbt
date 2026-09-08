///|
struct World {
  slots : Array[EntitySlot]
  free_slots : Array[Int]
  archetypes : Array[Archetype]
  systems : Array[SystemInfo] // The system data will be erased
}

///|
priv struct SystemInfo {
  debug_name : String
  system : System
}

///|
pub fn World::World() -> World {
  {
    slots: Array(capacity=512),
    free_slots: Array(capacity=256),
    archetypes: Array(capacity=64),
    systems: Array(capacity=16),
  }
}

///|
/// Query the component data with component type `key` which belongs to 
/// entity `entity`. 
/// When the entity does not have that component, returns `None`. 
pub fn[C] World::get_component(
  self : World,
  entity : Entity,
  key : ComponentKey[C],
) -> C? {
  guard self.get_location(entity) is Some(location) else { None }
  match key.columns.get(location.archetype_id) {
    Some(Some(column)) => column.get(location.row)
    _ => None
  }
  // It is wrong to do it by
  // `key.get_column(location.archetype_id).get(location.row)`
  // Because it is expected when the component is absent.
}

///|
/// Get or init the archetype of the component entries. Returns the archetype id
fn World::get_archetype(self : World, entries : Array[ComponentEntry]) -> Int {
  let mut mask = Bitmask(0)
  for entry in entries {
    guard (mask & entry.bitmask) == Bitmask(0) else {
      @tic80.abort_ascii(b"Duplicate component in spawn entries")
    }
    mask = mask | entry.bitmask
  }
  for id, archetype in self.archetypes {
    if archetype.components == mask.0 {
      return id
    }
  }
  let id = self.archetypes.length()
  let remove_operations = entries.map(entry => (entry.prepare)(id))
  let remove_components = fn(row) {
    for remove in remove_operations {
      remove(row)
    }
  }
  let archetype = { components: mask, entities: [], remove_components, }
  self.archetypes.push(archetype)
  id
}

///|
fn World::get_location(self : World, entity : Entity) -> Location? {
  guard self.slots.get(entity.index) is Some(slot) else { None }
  guard slot.generation == entity.generation else { None }
  slot.location
}

///|
pub fn World::entity_is_alive(self : World, entity : Entity) -> Bool {
  self.get_location(entity) is Some(_)
}

///|
pub fn World::spawn(self : World, entries : Array[ComponentEntry]) -> Entity {
  let archetype_id = self.get_archetype(entries)
  let archetype = self.archetypes[archetype_id]
  let row = archetype.entities.length()
  let entity = self.allocate_entity(archetype_id, row)
  archetype.entities.push(entity)
  for entry in entries {
    (entry.append)(archetype_id)
  }
  entity
}

///|
fn World::allocate_entity(
  self : World,
  archetype_id : Int,
  row : Int,
) -> Entity {
  let index = match self.free_slots.pop() {
    Some(index) => index
    None => {
      let index = self.slots.length()
      self.slots.push({ generation: 0, location: None, })
      index
    }
  }
  let slot = self.slots[index]
  let location = { archetype_id, row, }
  slot.location = Some(location)
  { index, generation: slot.generation, }
}

///|
pub fn World::despawn(self : World, entity : Entity) -> Unit {
  guard self.get_location(entity) is Some(location) else {
    @tic80.abort_ascii(b"Despawning a dead entity \{Repr(entity)}")
  }
  guard location is { archetype_id, row, }
  let archetype = self.archetypes[archetype_id]
  let last = archetype.entities.length() - 1
  let moved = archetype.entities[last]
  (archetype.remove_components)(row)
  swap_remove_row(archetype.entities, row)
  if row != last {
    self.slots[moved.index].location = Some({ archetype_id, row, })
  }
  let slot = self.slots[entity.index]
  slot.location = None
  // Retire exhausted slots 
  // Assume that slot generation is far less than UInt64::MAX
  slot.generation += 1
  self.free_slots.push(entity.index)
}

///|
fn World::execute_commands(self : World, commands : Array[Command]) -> Unit {
  for command in commands {
    match command {
      Spawn(entries) => self.spawn(entries) |> ignore
      Despawn(e) => self.despawn(e)
    }
  }
}

///|
pub fn World::add_system(
  self : World,
  debug_name : String,
  system_maker : (SystemFactory) -> System,
) -> Unit {
  let factory = SystemFactory(self.archetypes)
  let system = system_maker(factory)
  self.systems.push({ debug_name, system, })
}

///|
pub fn World::step(self : World) -> Unit {
  let command_emmitter = CommandEmitter()
  for system in self.systems {
    (system.system)(command_emmitter)
  }
  self.execute_commands(command_emmitter.commands)
}
