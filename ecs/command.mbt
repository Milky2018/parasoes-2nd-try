///|
priv enum Command {
  Spawn(&SpawnBundle)
  Despawn(Entity)
}

///|
struct CommandEmitter {
  commands : Array[Command]
}

///|
fn CommandEmitter::CommandEmitter() -> Self {
  { commands: [], }
}

///|
pub fn CommandEmitter::spawn(
  self : CommandEmitter,
  bundle : &SpawnBundle,
) -> Unit {
  self.commands.push(Spawn(bundle))
}

///|
pub fn CommandEmitter::despawn(self : CommandEmitter, entity : Entity) -> Unit {
  self.commands.push(Despawn(entity))
}
