///|
type System = (CommandEmitter) -> Unit

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
