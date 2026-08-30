extends GroundedEnemyMovement

@export var explode_sound_range: float = 300
@export var explosion_scene: PackedScene

func explode():
	for child in get_children():
		if child is SoundEmitterComponent:
			child.emit_sound(300)
	await get_tree().create_timer(0.05).timeout
	if explosion_scene:
		var boom = explosion_scene.instantiate()
		boom.global_position = global_position
		get_tree().current_scene.add_child.call_deferred(boom)
	queue_free()

func action_input(dir: Vector2):
	explode()
