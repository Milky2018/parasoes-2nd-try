///|
let world : @ecs.World = @ecs.World()

///|
pub fn tic() -> Unit {
  world.step()
}

///|
pub fn boot() -> Unit {
  world.add_system("sprite", @sprite.sprite_system)
  world.spawn([
    @sprite.sprite_ck.entry(player_tank_sprite),
    @position.pos_ck.entry(@position.Pos(@math.Vec2(0, 0))),
  ])
  |> ignore
}
