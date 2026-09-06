///|
struct Query1[C1] {
  archetypes : Array[Archetype]
  matches : Array[Int]
  mut scanned : Int
  c1_ck : ComponentKey[C1]
}

///|
fn[C1] Query1::refresh(self : Query1[C1]) -> Unit {
  let upper = self.archetypes.length()
  for archetype_id in self.scanned..<upper {
    let components = self.archetypes[archetype_id].components
    if components.contains(self.c1_ck.id) {
      self.matches.push(archetype_id)
    }
  }
  self.scanned = upper
}

///|
pub fn[C1] Query1::each(self : Query1[C1], f : (Entity, C1) -> Unit) -> Unit {
  self.refresh()
  for archetype_id in self.matches {
    let entities = self.archetypes[archetype_id].entities
    let c1 = self.c1_ck.get_column(archetype_id)
    for row in 0..<entities.length() {
      f(entities[row], c1[row])
    }
  }
}
