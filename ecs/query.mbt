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

///|
struct Query2[C1, C2] {
  archetypes : Array[Archetype]
  matches : Array[Int]
  mut scanned : Int
  c1_ck : ComponentKey[C1]
  c2_ck : ComponentKey[C2]
}

///|
fn[C1, C2] Query2::refresh(self : Query2[C1, C2]) -> Unit {
  let upper = self.archetypes.length()
  for archetype_id in self.scanned..<upper {
    let components = self.archetypes[archetype_id].components
    if components.contains(self.c1_ck.id) && components.contains(self.c2_ck.id) {
      self.matches.push(archetype_id)
    }
  }
  self.scanned = upper
}

///|
pub fn[C1, C2] Query2::each(
  self : Query2[C1, C2],
  f : (Entity, C1, C2) -> Unit,
) -> Unit {
  self.refresh()
  for archetype_id in self.matches {
    let entities = self.archetypes[archetype_id].entities
    let c1 = self.c1_ck.get_column(archetype_id)
    let c2 = self.c2_ck.get_column(archetype_id)
    for row in 0..<entities.length() {
      f(entities[row], c1[row], c2[row])
    }
  }
}
