///|
pub(all) struct Sprite {
  zindex : Int
  kind : SpriteKind
}

///|
pub(all) enum SpriteKind {
  AnimeSprite(AnimePlayer)
  ImageSprite(Image)
}

///|
pub let sprite_ck : @ecs.ComponentKey[Sprite] = @ecs.register_component(
  "sprite",
)

///|
pub fn sprite_system(factory : @ecs.SystemFactory) -> @ecs.System {
  let query = factory.query2(sprite_ck, @position.pos_ck)
  let sprites = []
  fn(_cmd) noraise {
    query.each(fn(_e, sprite, pos) { sprites.push((sprite, pos)) })
    sprites.sort_by_key(e_spr => e_spr.0.zindex)
    for e_spr in sprites {
      let pos = e_spr.1
      match e_spr.0.kind {
        AnimeSprite(anime_player) =>
          anime_player.play_step(pos.x.to_int(), pos.y.to_int())
        ImageSprite(image) => image.render(pos.x.to_int(), pos.y.to_int())
      }
    }
    sprites.clear()
  }
}
