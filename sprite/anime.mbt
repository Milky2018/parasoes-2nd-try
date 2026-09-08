///|
struct SpriteAnimation(FixedArray[AnimeFrame])

///|
struct AnimeFrame {
  sprite_id : Int
  duration : Int
  flip : @tic80.Flip
  rotate : @tic80.Rotation
  scale : Int
  width : Int
  height : Int
}

///|
pub fn AnimeFrame::AnimeFrame(
  sprite_id : Int,
  duration? : Int = 1,
  flip? : @tic80.Flip = NoFlip,
  rotate? : @tic80.Rotation = NoRotation,
  scale? : Int = 1,
  width? : Int = 1,
  height? : Int = 1,
) -> AnimeFrame {
  { sprite_id, duration, flip, rotate, scale, width, height, }
}

///|
struct AnimePlayer {
  animation : SpriteAnimation
  mut frame : Float
  rate : Float
}

///|
pub let anime_player_ck : @ecs.ComponentKey[AnimePlayer] = @ecs.register_component(
  "anime_player",
)

///|
pub fn anime_sprite_system(factory : @ecs.SystemFactory) -> @ecs.System {
  let query = factory.query1(anime_player_ck)
  fn(_cmd) {
    // query.each(fn (_e, anime_player))
  }
}
