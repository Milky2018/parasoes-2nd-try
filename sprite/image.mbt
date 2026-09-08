///|
struct Image {
  sprite_id : Int
  flip : @tic80.Flip
  rotate : @tic80.Rotation
  scale : Int
  width : Int
  height : Int
}

///|
pub fn Image::Image(
  sprite_id : Int,
  flip? : @tic80.Flip = NoFlip,
  rotate? : @tic80.Rotation = NoRotation,
  scale? : Int = 1,
  width? : Int = 1,
  height? : Int = 1,
) -> Image {
  { sprite_id, flip, rotate, scale, width, height, }
}

///|
pub fn Image::render(self : Image, x : Int, y : Int) -> Unit {
  @tic80.spr(
    self.sprite_id,
    x,
    y,
    flip=self.flip,
    scale=self.scale,
    rotate=self.rotate,
    w=self.width,
    h=self.height,
    transparent_colors=b"\x00", // The transparent color is always COLOR#0
  )
}
