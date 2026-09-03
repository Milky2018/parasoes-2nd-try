///|
#export_name("TIC")
pub fn tic() -> Unit {
  @tic80.cls(color=0)
  @tic80.map()
  // @tic80.print("Hello, Parasoes!", x=84, y=84) |> ignore
  @raw.raw_print(b"Hello, Parasoes", 84, 84, 15, false, 1, false) |> ignore
}

///|
#export_name("BOOT")
pub fn boot() -> Unit {

}
