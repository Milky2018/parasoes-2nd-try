///|
pub(all) struct Vec2 {
  mut x : Float
  mut y : Float
}

///|
pub fn Vec2::Vec2(x : Float, y : Float) -> Self {
  { x, y, }
}

///|
pub fn Vec2::zero() -> Vec2 {
  Vec2(0, 0)
}

///|
pub impl Add for Vec2 with fn add(this, other) {
  Vec2(this.x + other.x, this.y + other.y)
}

///|
pub extend Vec2 with Add::{add}

///|
pub impl Mul for Vec2 with fn mul(this, other) {
  Vec2(this.x * other.x, this.y * other.y)
}

///|
pub extend Vec2 with Mul::{mul}

///|
pub impl Div for Vec2 with fn div(this, other) {
  Vec2(this.x / other.x, this.y / other.y)
}

///|
pub extend Vec2 with Div::{div}

///|
pub impl Sub for Vec2 with fn sub(this, other) {
  Vec2(this.x - other.x, this.y - other.y)
}

///|
pub extend Vec2 with Sub::{sub}

///|
pub impl Neg for Vec2 with fn neg(this) {
  Vec2(-this.x, -this.y)
}

///|
pub extend Vec2 with Neg::{neg}

///|
pub fn Vec2::scalar_mul(this : Vec2, scalar : Float) -> Vec2 {
  Vec2(this.x * scalar, this.y * scalar)
}

///|
pub fn Vec2::scalar_div(this : Vec2, scalar : Float) -> Vec2 {
  Vec2(this.x / scalar, this.y / scalar)
}

///|
pub fn Vec2::distance(this : Vec2) -> Float {
  (this.x * this.x + this.y * this.y).sqrt()
}

///|
pub fn Vec2::dot(this : Vec2, other : Vec2) -> Float {
  this.x * other.x + this.y * other.y
}

///|
pub fn Vec2::distance_to(this : Vec2, other : Vec2) -> Float {
  ((this.x - other.x) * (this.x - other.x) +
  (this.y - other.y) * (this.y - other.y)).sqrt()
}

///|
pub fn Vec2::normalize(this : Vec2) -> Vec2 {
  let mag = this.distance()
  if mag > 0.0 {
    Vec2(this.x / mag, this.y / mag)
  } else {
    Vec2(0.0, 0.0) // Default direction if magnitude is zero
  }
}
