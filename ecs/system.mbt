///|
pub type System = (CommandEmitter) -> Unit

///|
struct SystemFactory {
  archetypes : Array[Archetype]
}

///|
fn SystemFactory::SystemFactory(archetypes : Array[Archetype]) -> Self {
  { archetypes, }
}

///|
pub fn[C1] SystemFactory::query1(
  self : SystemFactory,
  ck : ComponentKey[C1],
) -> Query1[C1] {
  { archetypes: self.archetypes, matches: [], scanned: 0, c1_ck: ck, }
}

///|
pub fn[C1, C2] SystemFactory::query2(
  self : SystemFactory,
  ck1 : ComponentKey[C1],
  ck2 : ComponentKey[C2],
) -> Query2[C1, C2] {
  {
    archetypes: self.archetypes,
    matches: [],
    scanned: 0,
    c1_ck: ck1,
    c2_ck: ck2,
  }
}

///|
pub fn[R] SystemFactory::resource(
  _self : SystemFactory,
  rk : ResourceKey[R],
) -> R {
  rk.value
}
