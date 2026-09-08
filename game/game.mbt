///|
let world : @ecs.World = @ecs.World()

///|
pub fn tic() -> Unit {
  world.step()
}

///|
pub fn boot() -> Unit {
  world.add_system("sprite", @sprite.sprite_system)
  // world.spawn([])
}
