///|
test "component entries preserve columns and deferred commands" {
  let world = @ecs.World()
  let number : @ecs.ComponentKey[Int] = @ecs.register_component("test_number")
  let label : @ecs.ComponentKey[String] = @ecs.register_component("test_label")
  let first = world.spawn([number.entry(10), label.entry("first")])
  let second = world.spawn([label.entry("second"), number.entry(20)])
  let lone = world.spawn([number.entry(30)])
  let empty = world.spawn([])
  assert_eq(world.get_component(first, number), Some(10))
  assert_eq(world.get_component(second, label), Some("second"))
  assert_eq(world.get_component(lone, label), None)
  world.despawn(first)
  assert_eq(world.get_component(second, number), Some(20))
  assert_eq(world.get_component(second, label), Some("second"))
  assert_false(world.entity_is_alive(first))
  world.despawn(empty)
  assert_false(world.entity_is_alive(empty))
  let seen : Array[(Int, String)] = []
  let mut queued = false
  world.add_system("spawn_entries", factory => {
    let query = factory.query2(number, label)
    fn(cmd) {
      query.each(fn(_e, n, s) { seen.push((n, s)) })
      if !queued {
        cmd.despawn(second)
        cmd.spawn([number.entry(40), label.entry("deferred")])
        queued = true
      }
    }
  })
  world.step()
  assert_eq(seen.length(), 1)
  assert_eq(seen[0], (20, "second"))
  assert_false(world.entity_is_alive(second))
  seen.clear()
  world.step()
  assert_eq(seen.length(), 1)
  assert_eq(seen[0], (40, "deferred"))
}
