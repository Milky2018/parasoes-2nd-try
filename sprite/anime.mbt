///|
struct AnimePlayer {
  animation : FixedArray[Image]
  mut frame_offset : Float
  rate : Float
}

///|
pub fn AnimePlayer::AnimePlayer(
  animation : FixedArray[Image],
  rate? : Float = 1.0,
) -> Self {
  { animation, rate, frame_offset: 0, }
}

///|
pub fn AnimePlayer::play_step(self : AnimePlayer, x : Int, y : Int) -> Unit {
  let image = self.animation[self.frame_offset.to_int()]
  image.render(x, y)
  self.frame_offset += self.rate
  if self.frame_offset.to_int() >= self.animation.length() {
    self.frame_offset -= Float::from_int(self.animation.length())
  }
}
