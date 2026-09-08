///|
priv enum Command {
  Spawn(Array[ComponentEntry])
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
  entries : Array[ComponentEntry],
) -> Unit {
  self.commands.push(Spawn(entries))
}

///|
pub fn CommandEmitter::despawn(self : CommandEmitter, entity : Entity) -> Unit {
  self.commands.push(Despawn(entity))
}
