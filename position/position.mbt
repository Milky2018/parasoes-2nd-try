///|
pub(all) struct Pos(@math.Vec2)

///|
pub let pos_ck : @ecs.ComponentKey[Pos] = @ecs.register_component("pos")
