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
  let anime_len = Float::from_int(self.animation.length())
  guard self.frame_offset >= 0 && self.frame_offset < anime_len else {
    @tic80.abort_ascii(
      b"Anime playing out of length \{anime_len}, frame offset is \{self.frame_offset}",
    )
  }
  let image = self.animation[self.frame_offset.to_int()]
  image.render(x, y)
  self.frame_offset += self.rate
  if self.frame_offset >= anime_len {
    self.frame_offset -= anime_len
  }
}
