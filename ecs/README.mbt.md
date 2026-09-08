# Parasoes/ecs

## Limits

This is not a general ecs framework. This is only for the game Parasoes. 

Thus, for limits on the memory usage and cart size, there will be:

1. One single world
2. Up to 64 types of components 
3. Up to 512 entities
4. The archetype of each entity is not mutable, so the entity can only be spawned with a fixed set of components
5. Systems and components cannot be dynamically registered

## The Component Storage 

All components are stored in a variety of Archetypes. 

Assume we have three archetypes in the world:

```
Archetype #0 = { Pos }
Archetype #1 = { Pos, Vel }
Archetype #2 = { Vel, Health }
```

And we spawn 6 entities in this order:

```
E0 with P0
E1 with V1, H1 
E2 with P2, V2 
E3 with P3 
E4 with V4, H4
E5 with P5, V5
```

The logical structure of the component storages are like this:

```
Archetype #0 = { Pos }
  Pos Column = [ P0, P3 ]

Archetype #1 = { Pos, Vel }
  Pos Column = [ P2, P5 ]
  Vel Column = [ V2, V5 ]

Archetype #2 = { Vel, Health }
  Vel Column = [ V1, V4 ]
  Health Column = [ H1, H4 ]
```

As declared in the limits, the archetype of each entity is not mutable, so the entity is associated with an archetype. The query on an archetype is always dense, which is fast. 

## ComponentKey 

The mapping of a component type from archetype id to column index are stored in `ComponentKey`s. Eeach `ComponentKey` is like:

```
Pos Key = { Archetype #0 -> 0, Archetype #1 -> 0 }
Vel Key = { Archetype #1 -> 1, Archetype #2 -> 0 }
Health Key = { Archetype #2 -> 1 }
```

Which means: if we want to get the `Pos` of an entity, for example, `E5`. First, we know `E5` is in `Archetype #1` which is stored in the entity itself. Then we know from the `Pos Key` that the column index of `Pos` in `Archetype #1` is 0. So we can get the `Pos` of `E5` by `archetypes[1].columns[0][E5.index]`.

## How to Query on the Component Sets? 

See, the query API is designed to get a collection of component data on a specific set of components, which is also an achetype in our framework. Suppose there is a query on set {c0, c1}:

```
let query : Query2[C0, C1] = world.query2(c0, c1)
```

## Full Example

Instantiate a world singleton:

```mbt nocheck
///|
let world : World = World()
```

Define your components:

```mbt nocheck
///|
struct Pos {
  mut x : Double
  mut y : Double
}

///|
let pos_ck : ComponentKey[Pos] = register_component("pos")

///|
struct Vel {
  mut x : Double
  mut y : Double
}

///|
let vel_ck : ComponentKey[Vel] = register_component("vel")
```

Define the move system:

```mbt nocheck
///|
fn move_system(factory : SystemFactory) -> System {
  let query = factory.query2(pos_ck, vel_ck)

  fn(cmd) {
    query.each(fn(_e, pos, vel) {
      pos.x += vel.x
      pos.y += vel.y
    })
  }
}
```

Register this system and add your entity in the `BOOT` function:

```mbt nocheck
///|
#export_name("BOOT")
pub fn boot() -> Unit {
  world.add_system("move", move_system)
  world.spawn([pos_ck.entry({ x: 0, y: 0, }), vel_ck.entry({ x: 1, y: -1, })])
}
```

Run `World::step` in the `TIC` function:

```mbt nocheck
///|
#export_name("TIC")
pub fn tic() -> Unit {
  world.step()
}
```

Do not manipulate the `world` global value anywhere else (for example, in the systems). 

Spawn or despawn entities with `CommandEmmiter::spawn` and `CommandEmmiter::despawn`. 
